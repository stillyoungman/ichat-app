//
//  String.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

extension String {
    func log(){
        #if ENABLE_CONSOLE_LOGGING
        print(self)
        #endif
    }
}
