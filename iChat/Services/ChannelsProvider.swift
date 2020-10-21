//
//  ChannelsProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import Firebase

class ChannelsProvider {
    static let shared = ChannelsProvider()
    
    lazy var db = Firestore.firestore()
    lazy var channelsCollection = db.collection("channels")
    var channelsChangedListener: ListenerRegistration?
    
    var items: [Channel] = []
    
    private init() {
        channelsCollection.getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting channels: \(err)")
            } else {
                self?.items = ChannelsProvider.sorted(querySnapshot?.documents.compactMap({ Channel(with: $0) }) ?? [])
            }
        }
    }

}

extension ChannelsProvider: IChannelsProvider {
    func subscribe(_ channelsChangedHandler: @escaping () -> Void) {
        if channelsChangedListener != nil { channelsChangedListener?.remove() }
        
        channelsChangedListener = channelsCollection.addSnapshotListener { [weak self] querySnapshot, err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                guard let sSelf = self else { return }
                sSelf.items = ChannelsProvider.sorted(querySnapshot?.documents.compactMap({ Channel(with: $0) }) ?? [])
                channelsChangedHandler()
            }
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
    
    func unsubsribe() {
        channelsChangedListener?.remove()
    }
}
