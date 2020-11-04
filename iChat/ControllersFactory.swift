//
//  ControllersFactory.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ControllersFactory {
    static func userPageViewController(container: IServiceResolver) -> UserPageViewController {
        let userPageVC = UserPageViewController()
        userPageVC.setupDependencies(with: container)
        
        let profileInfoProvider: IProfileInfoProvider = container.resolve()
        userPageVC.setModel(profileInfoProvider.profile)
        
        let navigationController = UINavigationController(rootViewController: userPageVC)
        navigationController.setupAppearance(with: container.resolve())
        
        return userPageVC
    }
    
    static func conversationViewController(container: IServiceResolver) -> ConversationViewController {
        let controller = ConversationViewController()
        controller.setupDependencies(with: container)
        return controller
    }
    
    static func conversationsListViewController(container: IServiceResolver) -> ConversationsListViewController {
        let controller = ConversationsListViewController.instantiate(container: container)
        _ = AppNavigationViewController.create(withRoot: controller)
        
        return controller
    }
}
