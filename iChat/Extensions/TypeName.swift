//
//  TypeName.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol TypeName: AnyObject {
    static var typeName: String { get }
}

// Swift Objects
extension TypeName {
    static var typeName: String {
        return String(describing: self)
    }
}

// Bridge to Obj-C
extension NSObject: TypeName {
    static var typeName: String {
        return String(describing: self)
    }
}
