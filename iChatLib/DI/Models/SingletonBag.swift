//
//  SingletonBag.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class SingletonBag<TType>: ServiceBag<TType> {
    typealias ItemType = TType
    
    var value: TType?
    
    override func resolve(_ container: IServiceResolver) -> Any {
        if value == nil {
            value = factory(container)
        }
        return value!
    }
}
