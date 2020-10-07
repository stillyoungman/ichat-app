//
//  IConversation.swift
//  iChat
//
//  Created by Constantine Nikolsky on 06.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IConversation {
    var uid: String { get }
    var messages: Dictionary<Date, Array<IMessage>> { get }
    var dates: Array<Date> { get }
    func getDate(for indexPath: IndexPath) -> Date
    func getMessage(for indexPath: IndexPath) -> IMessage
}
