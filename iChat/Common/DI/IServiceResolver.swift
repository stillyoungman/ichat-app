//
//  IServiceResolver.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IServiceResolver {
    func resolve<T>(for type: T.Type) -> T
}

extension IServiceResolver {
    func resolve<T>() -> T {
        resolve(for: T.self)
    }
}
