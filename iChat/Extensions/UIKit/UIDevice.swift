//
//  UIDevice.swift
//  iChat
//
//  Created by Constantine Nikolsky on 22.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    static var vendorUid: String { UIDevice.current.identifierForVendor!.uuidString }
}
