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
    
    static let container: IContainer = {
        let container = Container()
        configure(container)
        return container
    }()
    
    static func setupRootViewController(_ window: UIWindow) {
        window.rootViewController = AppNavigationViewController
            .create(withRoot: ConversationsListViewController.instantiate(container: container))
        window.makeKeyAndVisible()
    }
    
    private static func configure(_ container: IContainer) {
        container.register(ConversationsInfoProvider.instance as IConversationsInfoProvider)
        container.register(DummyConversationsProvider.instance as IConversationsProvider)
        container.register(DummyProfileProvider.init() as IProfileInfoProvider)
        container.register(ThemeManager.shared as IThemeManager)
        container.register(ThemeManager.shared as IThemeProvider)
    }
}
