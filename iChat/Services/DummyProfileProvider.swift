//
//  ProfileProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 08.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class DummyProfileProvider: IProfileInfoProvider {
    let profile: IProfileInfo = ProfileInfo(username: "Constantine Nikolsky",
                              about: "Junior iOS developer",
                              location: "Moscow, Russia",
                              image: UIImage(named: "droid"))
}

