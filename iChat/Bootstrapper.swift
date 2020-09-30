//
//  Bootstrapper.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class Bootstrapper {
    private init() { }
    
    static func setupRootViewController(_ window: UIWindow) {
        window.rootViewController = AppNavigationViewController.create(withRoot: ConversationsListViewController.fromStoryboard())
//        window.rootViewController = UINavigationController(rootViewController: ConversationViewController.fromStoryboard())
        window.makeKeyAndVisible()
    }
}
