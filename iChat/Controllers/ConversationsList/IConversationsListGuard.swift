//
//  IConversationsListGuard.swift
//  iChat
//
//  Created by Constantine Nikolsky on 03.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversationsListGuard {
    func shouldBeAbleToAlter(channel: Channel) -> Bool
    func validChannelName(of text: String?) -> String?
    func isValidChannelName(_ text: String?) -> Bool
}
