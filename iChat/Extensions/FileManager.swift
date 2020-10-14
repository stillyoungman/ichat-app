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
    var documents: URL {
        self.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
