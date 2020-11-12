//
//  IViewContextProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

protocol IViewContextProvider {
    var viewContext: NSManagedObjectContext { get }
}
