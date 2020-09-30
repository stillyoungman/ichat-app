//
//  AppNavigationBar.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class AppNavigationBar: UINavigationBar {
    private let customBottomPadding: CGFloat = 7
    private var previousHeight: CGFloat = 0
    
    private var extendedDelegate: ExtendedNavBarDelegate? {
        delegate as? ExtendedNavBarDelegate
    }
    
    /// this aproach is quite fragile, but it's better than nothing :)
    /// also it causes small bug on iOS 12 devices: lack of buttom UINavigationBar's dash
    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            
            if stringFromClass.contains("UIBarBackground") {
                #if VISUAL_DEBUG
                subview.backgroundColor = .systemPink
                #endif
                subview.frame = CGRect(origin: subview.frame.origin,
                                       size: CGSize(width: subview.frame.width,
                                                    height: subview.frame.height + customBottomPadding))
            } else if stringFromClass.contains("UINavigationBarLargeTitleView") {
                #if VISUAL_DEBUG
                subview.backgroundColor = .systemGreen
                #endif
            } else if stringFromClass.contains("UINavigationBarContentView") {
                #if VISUAL_DEBUG
                subview.backgroundColor = .purple
                #endif
                subview.frame = CGRect(origin: subview.frame.origin,
                                       size: CGSize(width: subview.frame.width,
                                                    height: subview.frame.height + customBottomPadding))
            }
        }
    }
}
