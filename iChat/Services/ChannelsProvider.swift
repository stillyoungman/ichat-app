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
        
        // clear cache
        Firestore.firestore().clearPersistence { if let err = $0 { logger.log("Firebase. %@",
                                                                              category: .externalServices,
                                                                              .error,
                                                                              err.localizedDescription) } }
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
        channelsCollection.getDocuments(source: .server) { [weak self] querySnapshot, err in
            if let err = err {
                self?.logger.log("Firebase. %@", category: .externalServices, .error, err.localizedDescription)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                completionHandler(querySnapshot.documents.compactMap { Channel(with: $0) })
            }
        }
    }
}

extension ChannelsProvider: IChannelsManager {
    func create(with name: String) {
        let channel = Channel(identifier: "",
                              name: name,
                              lastMessage: nil,
                              lastActivity: nil,
                              ownerId: UIDevice.vendorUid )
        
        channelsCollection.addDocument(data: channel.data)
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
    
    func remove(_ channel: IChannel) {
        channelsCollection
            .document(channel.identifier)
            .delete()
        }
}
