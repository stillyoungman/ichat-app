//
//  NSFetchedResultsController+Extensions.swift
//  iChat
//
//  Created by Constantine Nikolsky on 10.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

extension NSFetchedResultsController {
    
    /// Check whether provided indexPath is valid.
    ///
    /// - note: This method checks if self.section is greater than indexPath.section
    /// and if number of object in indexPath.section is greater than indexPath.row
    ///
    /// - parameter indexPath: indexPath to be checked.
    ///
    /// - returns: Whether indexPath has a value associated to it.
    @objc func hasObject(at indexPath: IndexPath) -> Bool {
        guard let sections = self.sections, sections.count > indexPath.section else {
            return false
        }

        let sectionInfo = sections[indexPath.section]

        guard sectionInfo.numberOfObjects > indexPath.row else {
            return false
        }

        return true
    }
}
