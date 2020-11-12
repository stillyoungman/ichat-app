//
//  ConversationCell+Extensions.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

extension ConversationCell: IContextDependentComponent {
    static func initialize(with context: ApplicationContext) {
        _appContext = context
    }
}

extension ConversationCell: INibView {
    
}
