//
//  TextField.swift
//  iChat
//
//  Created by Constantine Nikolsky on 14.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let paddedRect = bounds.inset(by: self.padding)
        if self.leftViewMode == .always || self.leftViewMode == .unlessEditing {
            return self.adjustRectOriginForLeftView(bounds: paddedRect)
        }
        return paddedRect
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let paddedRect = bounds.inset(by: self.padding)
        if self.leftViewMode == .always || self.leftViewMode == .unlessEditing {
            return self.adjustRectOriginForLeftView(bounds: paddedRect)
        }
        return paddedRect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let paddedRect = bounds.inset(by: self.padding)
        if self.leftViewMode == .always || self.leftViewMode == .unlessEditing {
            return self.adjustRectOriginForLeftView(bounds: paddedRect)
        }
        return paddedRect
    }
    
    func adjustRectOriginForLeftView(bounds: CGRect) -> CGRect {
        var paddedRect = bounds
        paddedRect.origin.x += self.leftView!.frame.width
        return paddedRect
    }
}
