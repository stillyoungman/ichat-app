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
    static let deviceUid: String = UIDevice.vendorUid
    
    lazy var db = Firestore.firestore()
    lazy var channel = db.collection("channels").document(channelUid)
    lazy var messagesCollection = db.collection("channels").document(channelUid).collection("messages")
    var messagesChangedListener: ListenerRegistration?
    
    init(channel uid: String) {
        self.channelUid = uid
    }
    
    var messages: [Message] = []
    var dates: [Date] = []
    
    func subscribe(_ messagesChangedHandler: @escaping () -> Void) {
        if messagesChangedListener != nil { messagesChangedListener?.remove() }
        
        messagesChangedListener = messagesCollection.addSnapshotListener { [weak self] (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                guard let sSelf = self, let snapshot = querySnapshot else { return }
                sSelf.messages = snapshot.documents
                    .compactMap { Message(with: $0, deviceUid: FirebaseConversation.deviceUid) } 
                    .sorted { $0.date > $1.date }
                messagesChangedHandler()
            }
        }
    }
    
    func unsubscribe() {
        messagesChangedListener?.remove()
    }
    
    func send(_ content: String, from user: String) {
        let message: [String: Any] = [
            "content": content,
            "senderName": user,
            "senderId": UIDevice.vendorUid,
            "created": Firebase.Timestamp()
        ]
        
        messagesCollection.addDocument(data: message) { [weak self] err in
            if err == nil {
                self?.channel.setData(["lastMessage": content], merge: true)
            }
        }
    }
}
