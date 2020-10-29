//
//  NSManagedChannel.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

class NSManagedChannel: NSManagedObject {
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(_ context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Channel", in: context)!, insertInto: context)
    }
    
    @NSManaged var identifier: String
    @NSManaged var name: String
    @NSManaged var lastMessage: String?
    @NSManaged var lastActivity: Date?
    @NSManaged var ownerId: String?
    
    @NSManaged var messages: NSSet?
    
    static func fetchRequest() -> NSFetchRequest<NSManagedChannel> {
        return NSFetchRequest<NSManagedChannel>(entityName: "Channel")
    }
}

extension NSManagedChannel {
    convenience init(_ id: String, _ name: String, of context: NSManagedObjectContext) {
        self.init(context)
        identifier = id
        self.name = name
    }
    
    convenience init(_ channel: Channel, of context: NSManagedObjectContext) {
        self.init(context)
        identifier = channel.identifier
        name = channel.name
        lastMessage = channel.lastMessage
        lastActivity = channel.lastActivity
        ownerId = channel.ownerId
    }
}
