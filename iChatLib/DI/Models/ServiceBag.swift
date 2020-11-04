//
//  ServiceBag.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class ServiceBag<TType>: IServiceBag {
    var types: [ObjectIdentifier] = []
    let factory: (IServiceResolver) -> TType
    
    func resolve(_ container: IServiceResolver) -> Any {
        fatalError("Abstract method.")
    }
    
    func hasRegistration(for objectId: ObjectIdentifier) -> Bool {
        types.contains(objectId)
    }
    
    init<T1>(_ factoryMethod: @escaping (IServiceResolver) -> TType,
             _ t1: T1.Type) {
        factory = factoryMethod
        
        types.append(ObjectIdentifier(t1))
    }
    
    init<T1, T2>(_ factoryMethod: @escaping (IServiceResolver) -> TType,
                 _ t1: T1.Type,
                 _ t2: T2.Type) {
        factory = factoryMethod
        
        types.append(ObjectIdentifier(t1))
        types.append(ObjectIdentifier(t2))
    }
    
    init<T1, T2, T3>(_ factoryMethod: @escaping (IServiceResolver) -> TType,
                     _ t1: T1.Type,
                     _ t2: T2.Type,
                     _ t3: T3.Type) {
        factory = factoryMethod
        
        types.append(ObjectIdentifier(t1))
        types.append(ObjectIdentifier(t2))
        types.append(ObjectIdentifier(t3))
    }
    
    init<T1, T2, T3, T4>(_ factoryMethod: @escaping (IServiceResolver) -> TType,
                         _ t1: T1.Type,
                         _ t2: T2.Type,
                         _ t3: T3.Type,
                         _ t4: T4.Type) {
        factory = factoryMethod
        
        types.append(ObjectIdentifier(t1))
        types.append(ObjectIdentifier(t2))
        types.append(ObjectIdentifier(t3))
        types.append(ObjectIdentifier(t4))
    }
}
