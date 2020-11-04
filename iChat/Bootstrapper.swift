//
//  Bootstrapper.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit
import iChatLib

class Bootstrapper {
    private init() { }
    
    static let container: IContainer & IServiceResolver = {
        let container = Container()
        configure(container)
        return container
    }()
    
    static let logger = OSLogger("io.creative-socks.iChat")
    
    private static func configure(_ container: IContainer) {
        container.register(as: .singleton, ILogger.self) { _ in logger }
        container.register(as: .singleton, IConversationsProvider.self) { _ in ConversationProvider() }
        container.register(as: .singleton, IProfileInfoProvider.self) { _ in UserProfileManager.shared }
        container.register(as: .singleton,
                           IThemeManager.self,
                           IThemeProvider.self) { _ in ThemeManager.shared }
        container.register(as: .singleton,
                           IPersistentStorage.self,
                           IViewContextProvider.self) { _ in CoreDataStack.shared }
        
        container.register(as: .scoped, IChannelsProvider.self, factory: ComponentsFactory.channelsProvider)
        container.register(as: .scoped, IDataManager.self, factory: ComponentsFactory.applicationDataManager)
        
        container.register(as: .transient, factory: ControllersFactory.userPageViewController)
        container.register(as: .transient, factory: ControllersFactory.conversationViewController)
        container.register(as: .transient, factory: ControllersFactory.conversationsListViewController)
    }
    
    static func initApplication(_ window: UIWindow) {
        logger.logBegin()
        
        configureComponents()
        configureNotificationObservers()
        
        window.rootViewController = container.resolve(for: ConversationsListViewController.self).forPresentation
        
        window.makeKeyAndVisible()
        
        logger.logEnd()
    }
    
    static func initSessionServices() {
        logger.logBegin()
        _ = container.resolve(for: DataFlowManager.self)
        logger.logEnd()
    }
    
    static func disposeSessionServices() {
        logger.logBegin()
        
        do {
            try container.nextScope(for: DataFlowManager.self)
            try container.nextScope(for: ChannelsProvider.self)
        } catch {
            assertionFailure("Crash while doing nextScope")
        }
        
        logger.logEnd()
    }
    
    static func configureComponents() {
        let appContext = ApplicationContext(deviceUid: UIDevice.vendorUid)
        ConversationCell.initialize(with: appContext)
        MessageCell.initialize(with: appContext)
    }
    
    static func configureNotificationObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(appMovedToBackground(_:)),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appIsGoingToForeground(_:)),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    }
    
    @objc static func appIsGoingToForeground(_ notification: NSNotification) {
        logger.logBegin()
        initSessionServices()
        logger.logEnd()
    }
    
    @objc static func appMovedToBackground(_ notification: NSNotification) {
        logger.logBegin()
        disposeSessionServices()
        logger.logEnd()
    }
}
