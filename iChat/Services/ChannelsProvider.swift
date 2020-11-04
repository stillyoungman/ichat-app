//
//  ChannelsProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import Firebase
import iChatLib

class ChannelsProvider {
    lazy var db = Firestore.firestore()
    lazy var channelsCollection = db.collection("channels")
    let logger: ILogger
    
    init(logger: ILogger) {
        self.logger = logger
    }
    
    static func toChangeOf(type: DocumentChangeType, _ doc: IDocument) -> Change<Channel>? {
        guard let channel = Channel(with: doc) else { return nil }
        switch type {
        case .added: return .created(channel)
        case .modified: return .updated(channel)
        case .removed: return .deleted(channel)
        }
    }
    
    deinit {
        logger.log("%@: DEINIT", category: .objectLifetime, .default, String(describing: self))
    }
}

extension ChannelsProvider: IChannelsProvider {
    func subscribe(_ channelsChangedHandler: @escaping ([Change<Channel>]) -> Void ) -> IDisposable {
        let listenerRegistration = channelsCollection
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] querySnapshot, err in
                
                if let err = err {
                    self?.logger.log("Firebase. %@", category: .externalServices, .error, err.localizedDescription)
                }
                
                guard let querySnapshot = querySnapshot else { return }
                
                let changes: [Change<Channel>] = querySnapshot.documentChanges(includeMetadataChanges: true)
                    .compactMap { ChannelsProvider.toChangeOf(type: $0.type, $0.document) }
                
                channelsChangedHandler(changes)
        }
        
        logger.log("%@: SUBSCRIPTION", category: .objectLifetime, .default, String(describing: self))
        return Disposable { listenerRegistration.remove() }
    }
    
    func synchronize(_ completionHandler: @escaping ([Channel]) -> Void) {
        channelsCollection.getDocuments { [weak self] querySnapshot, err in
            if let err = err {
                self?.logger.log("Firebase. %@", category: .externalServices, .error, err.localizedDescription)
            }
            
            guard let querySnapshot = querySnapshot else { return }
            
            completionHandler(querySnapshot.documents.compactMap { Channel(with: $0) })
        }
    }
    
    private static func sorted(_ channels: [Channel]) -> [Channel] {
        channels.sorted { first, second in
            var result: Bool?
            result = first.sortByMessageAvailability(second)
            if let result = result { return result }
            
            return first.sortByLastActivity(second) ?? false
        }
    }
    
    func rename(_ name: String, channel: Channel) {
        let channelRef = channelsCollection.document(channel.identifier)
        
        channelRef.getDocument { channelSnapshot, err in
            guard let channelSnapshot = channelSnapshot, err != nil else { return }
            
            if channelSnapshot.exists {
                channelRef.updateData([
                    "name": name
                ])
            }
        }
    }
    
    func create(_ channel: Channel) {
        channelsCollection.addDocument(data: channel.data)
    }
    
    func remove(_ channel: Channel) {
        remove(channel, successCallback: nil)
    }
    
    func remove(_ channel: Channel, successCallback: (() -> Void)?) {
        channelsCollection
            .document(channel.identifier)
            .delete { err in
                if err == nil {
                    successCallback?()
                }
        }
    }
}
