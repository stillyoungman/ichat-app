//
//  String.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

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
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let sSelf = self else { return true }
        return sSelf.isEmpty
    }
}
