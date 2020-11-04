//
//  Array+Utils.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

// MARK: NSLayoutConstraint
extension Array where Element == NSLayoutConstraint {
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key: Element] {
        self.reduce(into: [Key: Element]()) { dict, c in dict[selectKey(c)] = c }
    }
    
    var any: Bool { self.count > 0 }
}
