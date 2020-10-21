//
//  UILabel.swift
//  iChat
//
//  Created by Constantine Nikolsky on 24.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

extension UILabel {
    @discardableResult func fitFontForSize(_ constrainedSize: CGSize,
                                           maxFontSize: CGFloat = 100,
                                           minFontSize: CGFloat = 5,
                                           accuracy: CGFloat = 1) -> CGSize {
        assert(maxFontSize > minFontSize)

        var minFontSize = minFontSize
        var maxFontSize = maxFontSize
        var fittingSize = constrainedSize

        while maxFontSize - minFontSize > accuracy {
            let midFontSize: CGFloat = ((minFontSize + maxFontSize) / 2)
            font = font.withSize(midFontSize)
            fittingSize = sizeThatFits(constrainedSize)
            if fittingSize.height <= constrainedSize.height
                && fittingSize.width <= constrainedSize.width {
                minFontSize = midFontSize
            } else {
                maxFontSize = midFontSize
            }
        }

        return fittingSize
    }
}
