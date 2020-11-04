//
//  ScopedBag.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class ScopedBag<TType>: TransientBag<TType> {
    private var _cached: Any?
    
    override func resolve(_ container: IServiceResolver) -> Any {
        if _cached == nil {
            _cached = super.resolve(container)
        }
        return _cached!
    }
    
    func nextScope() {
        if let disposable = _cached as? IDisposable {
            disposable.dispose()
        }
        _cached = nil
    }
}
