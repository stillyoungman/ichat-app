//
//  TView.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

class PTView: UIView {
    override init(frame: CGRect) {
        Self.trace()
        super.init(frame: frame)
        trace()
    }
    
    required init?(coder: NSCoder) {
        Self.trace()
        super.init(coder: coder)
        trace()
    }
    
    override func awakeFromNib() {
        trace(.in)
        super.awakeFromNib()
        trace()
    }
    
    override func layoutIfNeeded() {
        trace(.in)
        super.layoutIfNeeded()
        trace()
    }
    
    override func layoutSubviews() {
        trace(.in)
        super.layoutSubviews()
        trace()
    }
    
    override func setNeedsLayout() {
        trace(.in)
        super.setNeedsLayout()
        trace()
    }
    
    override func setNeedsDisplay() {
        trace(.in)
        super.setNeedsDisplay()
        trace()
    }
    
    override func setNeedsDisplay(_ rect: CGRect) {
        trace(.in)
        super.setNeedsDisplay(rect)
        trace()
    }
    
    override func addSubview(_ view: UIView) {
        trace(.in)
        super.addSubview(view)
        trace()
    }
    
    override func didAddSubview(_ subview: UIView) {
        trace(.in)
        super.didAddSubview(subview)
        trace()
    }
    
    override func didMoveToWindow() {
        trace(.in)
        super.didMoveToWindow()
        trace()
    }
    
    override func didMoveToSuperview() {
        trace(.in)
        super.didMoveToSuperview()
        trace()
    }
    
    override func removeFromSuperview() {
        trace(.in)
        super.removeFromSuperview()
        trace()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        trace(.in)
        super.willMove(toSuperview: newSuperview)
        trace()
    }
    
    override func bringSubviewToFront(_ view: UIView) {
        trace(.in)
        super.bringSubviewToFront(view)
        trace()
    }
    
    override func becomeFirstResponder() -> Bool {
        trace(.in)
        defer { trace() }
        return super.becomeFirstResponder()
    }
}
