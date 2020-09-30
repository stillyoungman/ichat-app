//
//  ConversationInfo.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

/// comment #1
struct ConversationInfo: IConversationInfo {
    var name: String
    var message: String
    var date: Date
    var isOnline: Bool
    var hasUnreadMessages: Bool
}
