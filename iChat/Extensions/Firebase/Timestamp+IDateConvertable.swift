//
//  Timestamp+IDateConvertable.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import Firebase

extension Timestamp: IDateConvertable {
    var date: Date {
        self.dateValue()
    }
}
