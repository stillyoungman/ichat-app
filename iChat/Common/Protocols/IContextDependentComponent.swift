//
//  IContextDependentComponent.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

/// Purpose ot the protocol is to create single configuration point for components that depends on some global application data
protocol IContextDependentComponent {
    associatedtype ApplicationContext
    
    static func initialize(with context: ApplicationContext)
    static var _appContext: ApplicationContext? { get }
}

extension IContextDependentComponent {
    static var appContext: ApplicationContext {
        guard let context = _appContext else {
            fatalError("It's required to intialize object that conforms to protocol IContextDependentComponent before usage. `\(String(describing: self)))`")
        }
        return context
    }
}
