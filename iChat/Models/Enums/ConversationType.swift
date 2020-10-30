//
//  ConversationType.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

enum ConversationType: Int {
    case undefined = -1, online = 0, history = 1
    
    static func parse(_ rawValue: Int) -> ConversationType {
        ConversationType(rawValue: rawValue) ?? ConversationType.undefined
    }
    
    func toString() -> String {
        switch self {
        case .online: return "Online"
        case .history: return "History"
        default: fatalError("ConversationType '\(self)' isn't supported.")
        }
    }
}
