//
//  ConversationsListGuard.swift
//  iChat
//
//  Created by Constantine Nikolsky on 03.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class ConversationsListGuard {
    var context: ApplicationContext!
}

extension ConversationsListGuard: IConversationsListGuard {
    func shouldBeAbleToAlter(channel: Channel) -> Bool {
        context.deviceUid == channel.ownerId
    }
    
    func validChannelName(of text: String?) -> String? {
        text?.trimmed
    }
    
    func isValidChannelName(_ text: String?) -> Bool {
        guard let text = text else { return false }
        return !text.trimmed.isEmpty
    }
}
