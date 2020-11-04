//
//  ConversationsListPresenter.swift
//  iChat
//
//  Created by Constantine Nikolsky on 31.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ConversationsListPresenter {
    
}

protocol IConversationListViewController {
    func updateAvatar()
    func updateTheme()
}

protocol IConversationListDependenciesProvider {
    var themeProvider: IThemeProvider { get }
    var storage: IPersistentStorage { get }
    var profile: IProfileInfo { get }
    
    var myAvatarView: AvatarView { get }
    
    var userPageViewController: UserPageViewController { get }
    var themesViewController: ThemesViewController { get }
}

protocol IConversationsListPresenter {
    associatedtype ChannelsDataSource: IDataSource where ChannelsDataSource.Item == Channel
    var source: ChannelsDataSource { get }
    
    var channels: IChannelsManager { get }
    var `guard`: IConversationsListGuard { get }
}

protocol IChannelsDataSource {
    associatedtype ChannelsDataSource: IDataSource where ChannelsDataSource.Item == Channel
    var source: ChannelsDataSource { get }
}

class DataSource<T>: IDataSource {
    typealias Item = T
    
    private let source: [T] = []
    
    func item(for indexPath: IndexPath) -> T {
        source[indexPath.row]
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        source.count
    }
}

protocol IDataSource: class {
    associatedtype Item
    
    func item(for indexPath: IndexPath) -> Item
    func numberOfRowsIn(section: Int) -> Int
}

//extension DataSource: ICDS where T == Channel {
//
//}
