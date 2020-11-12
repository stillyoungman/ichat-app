//
//  IContainer.swift
//  iChatLib
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

public protocol IContainer {
    func register<T>(as scope: ServiceLifetime,
                     factory method: @escaping (IServiceResolver) -> T)
    
    func register<T, T1>(as scope: ServiceLifetime,
                         _ t1: T1.Type,
                         factory method: @escaping (IServiceResolver) -> T)
    
    func register<T, T1, T2>(as scope: ServiceLifetime,
                             _ t1: T1.Type,
                             _ t2: T2.Type,
                             factory method: @escaping (IServiceResolver) -> T)
    
    func register<T, T1, T2, T3>(as scope: ServiceLifetime,
                                 _ t1: T1.Type,
                                 _ t2: T2.Type,
                                 _ t3: T3.Type,
                                 factory method: @escaping (IServiceResolver) -> T)
    
    func nextScope<T>(for type: T.Type) throws
}
