//
//  UILabelExtended.swift
//  iChat
//
//  Created by Constantine Nikolsky on 24.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

class UILabelExtended : UILabel {
    @IBInspectable open var characterSpacing:CGFloat = 1 {
        didSet {
            guard let text = self.text else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}
