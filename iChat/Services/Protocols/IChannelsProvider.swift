//
//  IChannelProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 22.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import iChatLib

protocol IChannelsProvider: IChannelsManager {    
    func subscribe(_ channelsChangedHandler: @escaping ([Change<Channel>]) -> Void ) -> IDisposable
    func synchronize(_ completionHandler: @escaping ([Channel]) -> Void)
}
