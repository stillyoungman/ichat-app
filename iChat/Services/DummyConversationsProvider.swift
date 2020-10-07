//
//  ConversationsProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 06.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class DummyConversationsProvider: IConversationsProvider {
    static let instance = DummyConversationsProvider()
    
    let conversation = DummyConversation()
    
    func conversation(for uid: String) -> IConversation {
        conversation
    }
    
    private init() { }
}

