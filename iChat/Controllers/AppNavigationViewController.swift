//
//  AppNavigationViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class AppNavigationViewController: UINavigationController {
    static func create(withRoot viewController: UIViewController) -> AppNavigationViewController{
        let nc = AppNavigationViewController(navigationBarClass: AppNavigationBar.self, toolbarClass: nil)
        nc.setViewControllers([viewController], animated: false)
        return nc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visibleViewController?.additionalSafeAreaInsets.top = 7
    }
}
