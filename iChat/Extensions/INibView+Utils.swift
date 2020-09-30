//
//  HasNib.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

extension INibView where Self: UIView {
    static var nib: UINib { return UINib(nibName: String(describing: self), bundle: nil) }
    static func fromNib() -> Self {
        guard let view = nib.instantiate(withOwner: Self.self, options: nil).first as? Self
            else { fatalError("Unable instanciate UIView '\(Self.typeName)' from Nib file") }
        return view
    }
}
