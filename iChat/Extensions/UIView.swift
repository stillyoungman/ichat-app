//
//  UIView.swift
//  iChat
//
//  Created by Constantine Nikolsky on 23.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    func addBorder(borderColor: UIColor = .clear, borderWith: CGFloat = 0, borderCornerRadius: CGFloat? = nil){
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = borderCornerRadius ?? cornerRadius
    }
    
    func removeBorder() {
        addBorder(borderColor: .clear, borderWith: 0, borderCornerRadius: 0)
    }
    
    var hasSuperview: Bool {
        return self.superview != nil
    }
    
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
    
    var nestedSubviews: [UIView] {
        subviews.reduce(into: []) { array, view in
            array.append(view)
            if view.subviews.count != 0 {
                array.append(contentsOf: view.nestedSubviews)
            }
        }
    }
    
    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}
