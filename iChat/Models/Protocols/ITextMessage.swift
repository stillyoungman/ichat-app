//
//  ITextMessage.swift
//  iChat
//
//  Created by Constantine Nikolsky on 06.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol ITextMessage: IMessage {
    var text: String { get }
}
