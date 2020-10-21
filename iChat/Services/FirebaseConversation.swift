//
//  FirebaseConversation.swift
//  iChat
//
//  Created by Constantine Nikolsky on 22.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import Firebase

class FirebaseConversation: IConversation {
    let channelUid: String
    static let deviceUid: String = UIDevice.current.identifierForVendor!.uuidString
    
    lazy var db = Firestore.firestore()
    lazy var messagesCollection = db.collection("channels").document(channelUid).collection("messages")
    var messagesChangedListener: ListenerRegistration?
    
    init(channel uid: String) {
        self.channelUid = uid
    }
    
    var messages: [IMessage] = []
    var dates: [Date] = []
    
    func subscribe(_ messagesChangedHandler: @escaping () -> Void) {
        if messagesChangedListener != nil { messagesChangedListener?.remove() }
        
        messagesChangedListener = messagesCollection.addSnapshotListener { [weak self] (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                guard let sSelf = self, let snapshot = querySnapshot else { return }
                sSelf.messages = snapshot.documents.compactMap({ Message(with: $0, deviceUid: FirebaseConversation.deviceUid) })
                messagesChangedHandler()
            }
        }
    }
    
    func unsubscribe() {
        messagesChangedListener?.remove()
    }
    
    func send() {
        
    }
}
