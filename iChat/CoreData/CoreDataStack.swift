//
//  CoreDataStack.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: IPersistentStorage {
    static let shared = CoreDataStack()
    private init() {
        enableObservers()
    }
    
    var chatObjectModel: NSManagedObjectModel {
        guard let modelURL = Bundle.main.url(forResource: "Chat", withExtension: "momd")
            else { fatalError("Model not found") }
        guard let objectModel = NSManagedObjectModel(contentsOf: modelURL)
            else { fatalError("Unable to initialize NSManagedObjectModel") }
        return objectModel
    }
    
    var storageURL: URL {
        FileManager.documentsURL.appendingPathComponent("chat_data.sqlite")
    }
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var result: NSPersistentStoreCoordinator?
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        // если вдруг эта операция очень долгая...
        DQ.global(qos: .default).async { [weak self] in
            do {
                guard let sSelf = self else { dispatchGroup.leave(); return }
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: sSelf.chatObjectModel)
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: sSelf.storageURL, options: nil)
                
                debug {
                    "begin loading of persistentStoreCoordinator".log()
                    sleep(10)
                    "finish loading of persistentStoreCoordinator".log()
                }
                
                result = coordinator
                // notification could be raised here.
                dispatchGroup.leave()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        dispatchGroup.wait()
        guard let coordinator = result else { fatalError("Unable to get strong ref to `self`") }
        return coordinator
    }()
    
    func beginLoading() {
        DQ.global(qos: .default).async { [weak self] in
            _ = self?.persistentStoreCoordinator
        }
    }
    
    // MARK: - Contexts
    
    private lazy var writerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.automaticallyMergesChangesFromParent = true
        context.parent = writerContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.automaticallyMergesChangesFromParent = true
        context.parent = mainContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    // MARK: - Save
    
    func performSave(_ populate: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            populate(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }
    
    // MARK: - Observers and Logs
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(contextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc
    private func contextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            "Inserted: \(inserts.count)".log()
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            "Updated: \(updates.count)".log()
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            "Deleted: \(deletes.count)".log()
        }
        
        debug { printInfo() }
    }
    
    func printInfo() {
        mainContext.perform { [weak self] in
            guard let sSelf = self else { return }
            do {
                let channelsCount = try sSelf.mainContext.count(for: NSManagedChannel.fetchRequest())
                "Channels: \(channelsCount)".log()
                
                let channels = try sSelf.mainContext.fetch(NSManagedChannel.fetchRequest()) as? [NSManagedChannel] ?? []
                channels.forEach { $0.name.log() }
                
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
