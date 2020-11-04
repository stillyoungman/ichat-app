//
//  IPersistentStorage.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

protocol IPersistentStorage {
    func save(_ modifyContext: (NSManagedObjectContext) -> Void, _ afterSave: (() -> Void)?)
}
