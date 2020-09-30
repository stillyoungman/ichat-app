//
//  StoryboardViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

extension IStoryboardViewController where Self: UIViewController {
    static func fromStoryboard() -> Self {
        let storyboardName = Self.typeName.replacingOccurrences(of: "ViewController", with: "")
        guard let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as? Self
            else { fatalError("Unable to load storiboard for name '\(storyboardName)' or instantiate ViewController") }
        return vc
    }
}
