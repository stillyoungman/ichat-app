//
//  IServiceBag.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IServiceRegistration {
    func hasRegistration(for objectId: ObjectIdentifier) -> Bool
}

protocol IServiceBag: IServiceRegistration {
    func resolve(_ container: IServiceResolver) -> Any
}
