//
//  ConversationInfoProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversationsProvider {
    associatedtype ConversationsCollection: Collection where ConversationsCollection.Element == IConversationInfo
    
    func conversations(for type: ConversationType) -> ConversationsCollection
}
