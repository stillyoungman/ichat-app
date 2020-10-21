//
//  IConversation.swift
//  iChat
//
//  Created by Constantine Nikolsky on 06.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversation {
    var channelUid: String { get }
    var messages: [IMessage] { get }
    
    func send()
    
    func subscribe(_ messagesChangedHandler: @escaping () -> Void)
    func unsubscribe()
}
