//
//  MessageCell+Extensions.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

extension MessageCell: IConfigurable {
    
    func configure(with model: IMessage) {
        let direction: Direction = model.isOutgoing(MessageCell.appContext.deviceUid) ? .out : .in
        activateConstraints(for: direction)
        bubble.activateConstraints(for: direction)
        setColor(for: direction)
        
        senderName.text = model.senderName
        
        if let textMessage = model as? ITextMessage {
            textView.text = textMessage.text
        }
    }
}

extension MessageCell: IContextDependentComponent {
    static func initialize(with context: ApplicationContext) {
        _appContext = context
    }
}
