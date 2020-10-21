//
//  IMessage.swift
//  iChat
//
//  Created by Constantine Nikolsky on 06.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IMessage {
    var uid: String { get }
    var time: String { get }
    var deliveryStatus: DeliveryStatus { get }
    
    var senderUid: String { get }
    var senderName: String { get }
    
    var deviceUid: String { get }
    
    var date: Date { get }
}

extension IMessage {
    var isOutgoing: Bool { deviceUid == senderUid }
}
