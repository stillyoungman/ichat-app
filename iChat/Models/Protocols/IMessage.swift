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
    var isOutgoing: Bool { get }
    
    var date: Date { get }
}
