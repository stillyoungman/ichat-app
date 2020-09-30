//
//  CGSize.swift
//  iChat
//
//  Created by Constantine Nikolsky on 01.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    func extended(_ x: CGFloat, _ y: CGFloat) -> CGSize {
        return CGSize(width: self.width + x, height: self.height + y)
    }
}
