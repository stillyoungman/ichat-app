//
//  IChannelsManager.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IChannelsManager {
    func create(with name: String)
    func remove(_ channel: IChannel)
    func rename(_ name: String, channel: Channel)
}
