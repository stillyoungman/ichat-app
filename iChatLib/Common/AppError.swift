//
//  AppError.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class AppError: Error {
    let info: String
    
    init(_ info: String? = nil) {
        self.info = info ?? "<<Empty>>"
    }
}
