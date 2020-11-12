//
//  ComponentsFactory.swift
//  iChat
//
//  Created by Constantine Nikolsky on 04.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import iChatLib

class ComponentsFactory {
    static func applicationDataManager(container: IServiceResolver) -> DataFlowManager {
        DataFlowManager(channelsProvider: container.resolve(),
                        persistence: container.resolve(),
                        logger: container.resolve(for: ILogger.self))
    }
    
    static func channelsProvider(container: IServiceResolver) -> ChannelsProvider {
        ChannelsProvider(logger: container.resolve())
    }
}
