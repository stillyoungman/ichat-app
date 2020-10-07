//
//  Container.swift
//  iChat
//
//  Created by Constantine Nikolsky on 07.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class Container {
    private var factories: [ObjectIdentifier: (Container) -> Any] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]
    private var scopes: [ObjectIdentifier: InstanceScope] = [:]
    
    private func resolveSingleton<T>(_ key: ObjectIdentifier) -> T {
        if let cached = singletons[key] as? T {
            return cached
        } else {
            guard let instance = factories[key]?(self) as? T else {
                fatalError("Unable to resolve service of type \(String(describing: T.self))")
            }
            singletons[key] = instance
            return instance
        }
    }
    
    private func resolvePerRequest<T>(_ key: ObjectIdentifier) -> T {
        guard let instance = factories[key]?(self) as? T else {
            fatalError("Unable to resolve service of type \(String(describing: T.self))")
        }
        return instance
    }
}

extension Container: IContainer {
    func register<T>(for scope: InstanceScope, factory method: @escaping  (IContainer) -> T) {
        let key = ObjectIdentifier(T.self)
        scopes[key] = scope
        factories[key] = method
    }
    
    func register<T>(_ instance: T) {
        let key = ObjectIdentifier(T.self)
        scopes[key] = .singleton
        singletons[key] = instance
    }
    
    func resolve<T>(for type: T.Type = T.self) -> T {
        let key = ObjectIdentifier(type)
        
        guard let scope = scopes[key] else {
            fatalError("Unable to resolve service of type \(String(describing: T.self))")
        }
        
        switch scope {
        case .perRequest:
            return resolvePerRequest(key)
        case .singleton:
            return resolveSingleton(key)
        }
    }
}

protocol IContainer: IServiceResolver {
    func register<T>(for scope: InstanceScope, factory method: @escaping (IContainer) -> T)
    func register<T>(_ singletonInstance: T)
}

protocol IServiceResolver {
    /// register as Singleton
    func resolve<T>(for type: T.Type) -> T
}

extension IServiceResolver {
    func resolve<T>() -> T {
        resolve(for: T.self)
    }
}

extension IContainer {
    func register<T>(factory method: @escaping (IContainer) -> T) {
        /// register as PerRequest instance
        register(for: .perRequest, factory: method)
    }
}

enum InstanceScope {
    case perRequest
    case singleton
}
