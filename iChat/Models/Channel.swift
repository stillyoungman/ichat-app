//
//  Channel.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

struct Channel: IChannel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    let ownerId: String?
}

protocol IChannel {
    var identifier: String { get }
    var name: String { get }
    var lastMessage: String? { get }
    var lastActivity: Date? { get }
    var ownerId: String? { get }
}

extension Channel {
    init?(with document: IDocument) {
        let data = document.data()
        guard let name = data["name"] as? String else { return nil }
        self.identifier = document.id
        self.name = name
        self.lastMessage = data["lastMessage"] as? String
        self.lastActivity = (data["lastActivity"] as? IDateConvertable)?.date
        self.ownerId = data["ownerId"] as? String
    }
}

extension IChannel {
    var hasNoMessages: Bool {
        self.lastMessage == nil
        //            || self.lastMessage?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }
    
    func sortByMessageAvailability(_ second: IChannel) -> Bool? {
        //if first has no message -> it has lower score
        if self.hasNoMessages { return false }
        
        //if second has no message -> first has higher score
        if second.hasNoMessages { return true }
        
        return nil
    }
    
    func sortByLastActivity(_ second: IChannel) -> Bool? {
        if let selfDate = self.lastActivity, let secondDate = second.lastActivity {
            return selfDate > secondDate
        }
        
        if self.lastActivity == nil && second.lastActivity == nil {
            return nil
        }
        
        // if self has `lastActivity` -> has highter priority
        return self.lastActivity != nil
    }
    
    var data: [String: Any] {
        return [
            "name": self.name,
            "ownerId": self.ownerId as Any
        ]
    }
}
