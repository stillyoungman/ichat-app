//
//  IDocument.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IDocument {
    var id: String { get }
    func data() -> [String: Any]
}
