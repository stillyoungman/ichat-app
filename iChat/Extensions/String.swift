//
//  String.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

extension String {
    func log() {
        #if ENABLE_CONSOLE_LOGGING
        print(self)
        #endif
    }
    
    var isEmpty: Bool { self.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 }
    
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // makes format string with arguments
    func formatWithParams(_ args: [CVarArg]) -> String {
        return withVaList(args) {
            String(NSString(format: self, arguments: $0))
        }
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let sSelf = self else { return true }
        return sSelf.isEmpty
    }
}
