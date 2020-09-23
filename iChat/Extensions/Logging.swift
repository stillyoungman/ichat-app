//
//  NSObject.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol Logging: AnyObject {
    static func trace(_ sign: Direction, functionName: String)
    func trace(_ sign: Direction, functionName: String)
}

extension NSObject: Logging {
    static func trace(_ sign: Direction = .in, functionName: String = #function) {
        "\(Self.typeName): \(sign.rawValue) \(functionName)".log()
    }
    
    func trace(_ sign: Direction = .out, functionName: String = #function){
        "\(String(describing: type(of: self))): \(sign.rawValue) \(functionName)".log()
    }
}
