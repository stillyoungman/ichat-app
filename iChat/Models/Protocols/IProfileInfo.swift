//
//  IProfileInfo.swift
//  iChat
//
//  Created by Constantine Nikolsky on 08.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

protocol IUsername {
    var username: String { get }
}

protocol IOptionalImage {
    var image: UIImage? { get }
}

protocol IProfileInfo: IUsername, IOptionalImage {
    var about: String { get }
    var location: String { get }
}
