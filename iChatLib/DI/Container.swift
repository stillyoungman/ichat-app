//
//  Container.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

public class Container {
    var serviceBags: [ServiceBag<Any>] = []
    
    public init() { }
    
    func failureIfNotUnique(_ identifiers: [ObjectIdentifier]) {
        for id in identifiers {
            if presented(id) {
                assertionFailure("Unable to register service, because provided type has already been registered.")
            }
        }
    }
    
    func presented(_ objectId: ObjectIdentifier) -> Bool {
        serviceBags.first { $0.hasRegistration(for: objectId) } != nil
    }
    
    func resolve(for objectId: ObjectIdentifier) -> Any? {
        serviceBags.first { $0.hasRegistration(for: objectId) }?.resolve(self)
    }
    
    func serviceBag(for objectId: ObjectIdentifier) -> ServiceBag<Any>? {
        serviceBags.first { $0.hasRegistration(for: objectId) }
    }
}

extension Container: IContainer {
    
    public func register<T>(as scope: ServiceLifetime,
                            factory method: @escaping (IServiceResolver) -> T) {
        failureIfNotUnique([ObjectIdentifier(T.self)])
        
        var bag: ServiceBag<Any>!
        
        switch scope {
        case .singleton: bag = SingletonBag(method, T.self)
        case .scoped: bag = ScopedBag(method, T.self)
        case .transient: bag = TransientBag(method, T.self)
        }
        
        serviceBags.append(bag)
    }
    
    public func register<T, T1>(as scope: ServiceLifetime,
                                _ t1: T1.Type,
                                factory method: @escaping (IServiceResolver) -> T) {
        failureIfNotUnique([ObjectIdentifier(T.self), ObjectIdentifier(t1)])
        
        var bag: ServiceBag<Any>!
        
        switch scope {
        case .singleton: bag = SingletonBag(method, T.self, t1)
        case .scoped: bag = ScopedBag(method, T.self, t1)
        case .transient: bag = TransientBag(method, T.self, t1)
        }
        
        serviceBags.append(bag)
    }
    
    public func register<T, T1, T2>(as scope: ServiceLifetime,
                                    _ t1: T1.Type,
                                    _ t2: T2.Type,
                                    factory method: @escaping (IServiceResolver) -> T) {
        failureIfNotUnique([ObjectIdentifier(T.self), ObjectIdentifier(t1), ObjectIdentifier(t2)])
        
        var bag: ServiceBag<Any>!
        
        switch scope {
        case .singleton: bag = SingletonBag(method, T.self, t1, t2)
        case .scoped: bag = ScopedBag(method, T.self, t1, t2)
        case .transient: bag = TransientBag(method, T.self, t1, t2)
        }
        
        serviceBags.append(bag)
    }
    
    public func register<T, T1, T2, T3>(as scope: ServiceLifetime,
                                        _ t1: T1.Type,
                                        _ t2: T2.Type,
                                        _ t3: T3.Type,
                                        factory method: @escaping (IServiceResolver) -> T) {
        failureIfNotUnique([ObjectIdentifier(T.self), ObjectIdentifier(t1), ObjectIdentifier(t2), ObjectIdentifier(t3)])
        
        var bag: ServiceBag<Any>!
        
        switch scope {
        case .singleton: bag = SingletonBag(method, T.self, t1, t2, t3)
        case .scoped: bag = ScopedBag(method, T.self, t1, t2, t3)
        case .transient: bag = TransientBag(method, T.self, t1, t2, t3)
        }
        
        serviceBags.append(bag)
    }
    
    public func nextScope<T>(for type: T.Type) throws {
        guard let serviceBag = serviceBag(for: ObjectIdentifier(type)),
            let scopedBag = serviceBag as? ScopedBag<Any> else { throw AppError("Unable to find scoped service.") }
        
        scopedBag.nextScope()
    }
}

extension Container: IServiceResolver {
    public func resolve<T>(for type: T.Type = T.self) -> T {
        let id = ObjectIdentifier(type)
        guard let instance = resolve(for: id) as? T
            else { fatalError("Unable to resolve service of type \(String(describing: T.self))") }
        
        return instance
    }
}
