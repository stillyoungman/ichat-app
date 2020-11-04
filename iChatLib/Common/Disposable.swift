//
//  Disposable.swift
//  iChat
//
//  Created by Constantine Nikolsky on 03.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

public class Disposable: IDisposable {
    private let disposeClosure: () -> Void
    
    public init(_ dispose: @escaping () -> Void) {
        disposeClosure = dispose
    }
    
    public func dispose() {
        disposeClosure()
    }
}
