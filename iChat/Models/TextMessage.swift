//
//  TextMessage.swift
//  iChat
//
//  Created by Constantine Nikolsky on 06.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

struct TextMessage: ITextMessage {
    let text: String
    let uid: String
    let time: String
    var deliveryStatus: DeliveryStatus
    let senderUid: String
    let isOutgoing: Bool
    let senderName: String = ""
    let deviceUid: String = ""
    
    let date: Date
}
