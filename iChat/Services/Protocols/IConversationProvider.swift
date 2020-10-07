//
//  IConversationProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 07.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversationsProvider {
    func conversation(for uid: String) -> IConversation
}
