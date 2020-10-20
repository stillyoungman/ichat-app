//
//  IConversationInfo+Utils.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

extension IConversationInfo {
    var hasNoMessages: Bool {
        message.isEmpty
    }
    
    func sortByUnreadMessage(_ second: IConversationInfo) -> Bool? {
        if self.hasUnreadMessages && second.hasUnreadMessages {
            return nil
        } else if self.hasUnreadMessages {
            return true
        } else {
            return false
        }
    }
    
    func sortByMessageAvailability(_ second: IConversationInfo) -> Bool? {
        //if first has no message -> it has lower score
        if self.message == "" { return false }
        
        //if second has no message -> first has higher score
        if second.message == "" { return true }
        
        return nil
    }
}
