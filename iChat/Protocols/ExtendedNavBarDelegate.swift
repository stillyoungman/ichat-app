//
//  ExtendedNavBarDelegate.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

protocol ExtendedNavBarDelegate: UINavigationBarDelegate {
    func heightWasChanged(_ height: CGFloat)
    func topSafeAreaInsetsNeedsToBeChanged(with value: CGFloat)
}

extension ExtendedNavBarDelegate {
    func heightWasChanged(_ height: CGFloat) { }
    func topSafeAreaInsetsNeedsToBeChanged(with value: CGFloat) { }
}
