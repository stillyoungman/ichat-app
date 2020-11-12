//
//  ILogger.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol ILogger {
    func log(_ message: String, category: LogCategory, _ level: LogLevel, _ args: CVarArg...)
}

enum LogCategory {
    case applicationFlow, objectLifetime, common, externalServices
}

enum LogLevel {
    case `default`, info, debug, error, fault
}

extension ILogger {
    func logBegin(_ methodName: String = #function) {
        self.log("%@: BEGIN", category: .applicationFlow, .default, methodName)
    }
    
    func logEnd(_ methodName: String = #function) {
        self.log("%@: END", category: .applicationFlow, .default, methodName)
    }
}
