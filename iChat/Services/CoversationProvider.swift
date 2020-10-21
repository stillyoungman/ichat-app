//
//  CoversationProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 22.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class ConversationProvider: IConversationsProvider {
    func conversation(for uid: String) -> IConversation {
        FirebaseConversation(channel: uid)
    }
}
