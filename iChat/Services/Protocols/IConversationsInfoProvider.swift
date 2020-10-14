//
//  ConversationInfoProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversationsInfoProvider {
    func conversations(for type: ConversationType) -> AnyCollection<IConversationInfo>
}

