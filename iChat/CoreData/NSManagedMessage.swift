//
//  NSManagedMessage.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

class NSManagedMessage: NSManagedObject {
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(_ context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
    }
    
    @NSManaged var identifier: String
    @NSManaged var content: String
    @NSManaged var created: Date
    @NSManaged var senderId: String
    @NSManaged var senderName: String
    @NSManaged var deviceUid: String
    
    @NSManaged var channel: NSManagedChannel
}

extension NSManagedMessage {
    convenience init(_ message: Message, of context: NSManagedObjectContext) {
        self.init(context)
        identifier = message.identifier
        content = message.content
        created = message.created
        senderId = message.senderId
        senderName = message.senderName
        deviceUid = deviceUid
    }
}
