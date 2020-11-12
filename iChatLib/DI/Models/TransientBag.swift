//
//  TransientBag.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class TransientBag<TType>: ServiceBag<TType> {
    override func resolve(_ container: IServiceResolver) -> Any {
        factory(container)
    }
}
