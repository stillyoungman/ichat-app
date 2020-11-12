//
//  OSLogger.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import os

class OSLogger: ILogger {
    init(_ subsystem: String) {
        self.subsystem = subsystem
        os_log("Logger has been initialized", log: common, type: .default)
    }
    
    let subsystem: String
    lazy var common: OSLog = { OSLog(subsystem: self.subsystem, category: "Common") }()
    lazy var appFlow: OSLog = { OSLog(subsystem: self.subsystem, category: "ApplicationFlow") }()
    lazy var objLifetime: OSLog = { OSLog(subsystem: self.subsystem, category: "ObjectsLifetime") }()
    
    func log(_ message: String, category: LogCategory, _ level: LogLevel, _ args: CVarArg...) {
        let logType = toOsLogType(level)
        
        let staticMessage = message.formatWithParams(args)
        
        switch category {
        case .applicationFlow: os_log("%@", log: appFlow, type: logType, staticMessage)
        case .objectLifetime: os_log("%@", log: objLifetime, type: logType, staticMessage)
        default: os_log("%@", log: common, type: logType, staticMessage)
        }
    }
    
    private func toOsLogType(_ level: LogLevel) -> OSLogType {
        switch level {
        case .debug: return .debug
        case .info: return .info
        case .default: return .default
        case .error: return .error
        case .fault: return .fault
        }
    }
}
