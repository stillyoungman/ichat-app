//
//  FileManager.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    static var documentsURL: URL {
        do {
            return try FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            fatalError("Uable to get access to `documentsURL`")
        }
    }
}
