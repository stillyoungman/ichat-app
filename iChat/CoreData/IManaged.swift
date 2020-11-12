//
//  IManaged.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

protocol IManaged where Self: NSManagedObject { }

extension IManaged where Self: NSManagedObject {
    static var fetchRequest: NSFetchRequest<Self> {
        NSFetchRequest<Self>(entityName: entity().name!)
    }
}
