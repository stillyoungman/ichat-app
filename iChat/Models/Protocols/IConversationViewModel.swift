//
//  IConversationViewMode.swift
//  iChat
//
//  Created by Constantine Nikolsky on 08.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversationViewModel {
    var conversation: IConversation { get }
    var title: String { get }
}
