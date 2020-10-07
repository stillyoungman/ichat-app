//
//  Utils.swift
//  iChat
//
//  Created by Constantine Nikolsky on 02.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class Utils {
    private init() { }
    
    static func debug(action: () -> ()) {
        #if DEBUGGING_MODE
        action()
        #endif
    }
}
