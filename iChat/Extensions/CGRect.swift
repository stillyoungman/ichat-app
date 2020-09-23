//
//  CGRect.swift
//  iChat
//
//  Created by Constantine Nikolsky on 24.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

extension CGRect {
    func toString() -> String {
        return "X:\(self.minX) Y:\(self.minY) W:\(self.width) H:\(self.height)"
    }
}
