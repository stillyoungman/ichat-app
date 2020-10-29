//
//  UIViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var forPresentation: UIViewController {
        self.navigationController ?? self
    }
}
