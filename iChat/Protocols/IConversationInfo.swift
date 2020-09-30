//
//  IConversationInfo.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversationInfo {
    var name: String { get }
    var message: String { get }
    var date: Date { get }
    var isOnline: Bool { get }
    var hasUnreadMessages: Bool { get }
}
