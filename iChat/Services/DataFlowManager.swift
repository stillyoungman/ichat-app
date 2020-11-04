//
//  DataFlowManager.swift
//  iChat
//
//  Created by Constantine Nikolsky on 03.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData
import iChatLib

// let's pray for happy end here...
/// The class suppose to be bridge between Firebase and CoreData
/// and entry point for all entities manipulations i.e. create, update...
class DataFlowManager {
    let channelsProvider: IChannelsProvider
    let persistence: IPersistentStorage
    var channelsSubscription: IDisposable!
    let logger: ILogger?
    
    init(channelsProvider: IChannelsProvider, persistence: IPersistentStorage, logger: ILogger? = nil) {
        self.channelsProvider = channelsProvider
        self.persistence = persistence
        self.logger = logger
        
        channelsProvider.synchronize { [weak self] in self?.synchronize(channels: $0) }
        channelsSubscription = channelsProvider.subscribe { [weak self] in self?.channelsWereChanged(changes: $0) }
    }
    
    deinit {
        logger?.log("%@: DEINIT", category: .objectLifetime, .default, String(describing: self))
    }
    
    func synchronize(channels: [Channel]) {
        logger?.logBegin()
        
        persistence.save({ context in
            // delete channels that aren't presented in channels selection
            let ids = channels.map { $0.identifier }
            let fetchReq = NSManagedChannel.fetchRequest()
            fetchReq.predicate = NSPredicate(format: "NOT (%K IN %@)", #keyPath(NSManagedChannel.identifier), ids)

            if let dontExist = try? context.fetch(fetchReq) as? [NSManagedObject] {
                for channel in dontExist {
                    context.delete(channel)
                }
            }
        }, nil)
        
        logger?.logEnd()
    }
    
    func channelsWereChanged(changes: [Change<Channel>]) {
        persistence.save({ context in
            // remove channels
            let toRemove = changes.filter { $0.isDeleted }.map { $0.value }
            if toRemove.any { removeFrom(context, channels: toRemove) }

            // create channels
            let toCreate = changes.filter { $0.isCreated }.map { $0.value }
            if toCreate.any { createIn(context, channels: toCreate) }

            // update channels
            let toUpdate = changes.filter { $0.isUpdated }.map { $0.value }
            if toUpdate.any { updateIn(context, channels: toUpdate) }
        }, nil)
    }
    
    func fetchByIdentifier(_ channels: [Channel]) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchReq = NSManagedChannel.fetchRequest()
        let ids = channels.map { $0.identifier }
        fetchReq.predicate = NSPredicate(format: "%K IN %@", #keyPath(NSManagedChannel.identifier), ids)
        
        return fetchReq
    }
    
    func removeFrom(_ context: NSManagedObjectContext, channels: [Channel]) {
        let fetchReq = fetchByIdentifier(channels)
        
        context.performAndWait {
            for item in (try? context.fetch(fetchReq) as? [NSManagedObject]) ?? [] {
                context.delete(item)
            }
        }
    }
    
    func createIn(_ context: NSManagedObjectContext, channels: [Channel]) {
        context.performAndWait {
            for channel in channels {
                context.insert(NSManagedChannel(channel, of: context))
            }
        }
    }
    
    func updateIn(_ context: NSManagedObjectContext, channels: [Channel]) {
        let fetchReq = fetchByIdentifier(channels)
        
        context.performAndWait {
            // put to dictionary to reduce (o)complexity
            let channelsToUpdate = ((try? context.fetch(fetchReq) as? [NSManagedChannel]) ?? [])
                .toDictionary { $0.identifier }
            
            for incomingChannel in channels {
                if let existedChannel = channelsToUpdate[incomingChannel.identifier] {
                    existedChannel.update(with: incomingChannel)
                }
            }
        }
    }
}

extension DataFlowManager: IDisposable {
    func dispose() {
        channelsSubscription.dispose()
        logger?.log("%@: DISPOSE", category: .objectLifetime, .default, String(describing: self))
    }
}
