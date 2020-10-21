//
//  Message.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    let deviceUid: String
}

extension Message {
    init?(with document: IDocument, deviceUid: String) {
        let data = document.data()
        if let content = data["content"] as? String,
        let created = (data["created"] as? IDateConvertable)?.date,
        let senderId = data["senderId"] as? String {
            self.content = content
            self.created = created
            self.senderId = senderId
            self.senderName = data["senderName"] as? String ?? "*Unkown*"
            self.identifier = document.id
            self.deviceUid = deviceUid
        } else {
            return nil
        }
    }
}

extension Message: ITextMessage {
    var text: String {
        content
    }
    
    var uid: String {
        identifier
    }
    
    var time: String {
        ""
    }
    
    var deliveryStatus: DeliveryStatus {
        .delivered
    }
    
    var senderUid: String {
        senderId
    }
    
    var date: Date {
        created
    }
}
