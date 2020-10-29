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
    
    private static func configure(_ container: IContainer) {
        container.register(for: .singleton) { _ in ConversationProvider() as IConversationsProvider }
        container.register(UserProfileManager.shared as IProfileInfoProvider)
        container.register(ThemeManager.shared as IThemeManager)
        container.register(ThemeManager.shared as IThemeProvider)
        container.register(ChannelsProvider.shared as IChannelsProvider)
        container.register(for: .singleton) { _ in CoreDataStack.shared as IPersistentStorage }
    }
    
    static func initApplication(_ window: UIWindow) {
        window.rootViewController = AppNavigationViewController.create(withRoot: ConversationsListViewController.instantiate(container: container))
        
        window.makeKeyAndVisible()
    }
}
