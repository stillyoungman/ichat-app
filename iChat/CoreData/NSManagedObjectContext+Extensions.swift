//
//  NSManagedObjectContext+Extensions.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
     func performSave() {
        self.performAndWait {
            do {
                try self.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = self.parent { parent.performSave() }
    }
    
    func performSave(_ populate: @escaping (NSManagedObjectContext) -> Void) {
            self.perform {
                populate(self)
                if self.hasChanges {
                    self.performSave()
                }
            }
        }
}
