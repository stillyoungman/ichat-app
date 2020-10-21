//
//  IChannelProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 22.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IChannelsProvider {
    var items: [Channel] { get }
    
    func subscribe(_ channelsChangedHandler: @escaping () -> Void)
    func unsubsribe()
}
