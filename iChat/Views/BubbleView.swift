//
//  SpeechBubble.swift
//  iChat
//
//  Created by Constantine Nikolsky on 05.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class BubbleView: UIView {
    var color: UIColor? = .clear {
        didSet {
            shapeLayer.fillColor = color?.cgColor
        }
    }
    let shapeLayer: CAShapeLayer = CAShapeLayer()
    let contentLayoutGuide: UILayoutGuide = {
        let lg = UILayoutGuide()
        lg.identifier = "Content Layout Guide"
        return lg
    }()
    
    let senderNameLayouGuide: UILayoutGuide = {
        let lg = UILayoutGuide()
        lg.identifier = "SenderName Layout Guide"
        return lg
    }()
    
    let timeLayoutGuide: UILayoutGuide = {
        let lg = UILayoutGuide()
        lg.identifier = "Time Layout Guide"
        return lg
    }()
    
    private var direction: Direction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
        
        setupLayoutGuides()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayoutGuides() {
        addLayoutGuide(contentLayoutGuide)
        addLayoutGuide(senderNameLayouGuide)
        addLayoutGuide(timeLayoutGuide)
        
        widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor, constant: 30).isActive = true
        centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor).isActive = true
        
        senderNameLayouGuide.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor).isActive = true
        senderNameLayouGuide.topAnchor.constraint(equalTo: topAnchor, constant: 23).isActive = true
        senderNameLayouGuide.bottomAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: -5).isActive = true
        senderNameLayouGuide.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor).isActive = true
        
        //TODO: time
    }
    
    var senderName: UIView? {
        didSet {
            guard let sn = senderName else { return /* could be reasonable to remove from superview old value */ }
            if let oldValue = oldValue { oldValue.removeFromSuperview() }
            addSubview(sn)
            sn.translatesAutoresizingMaskIntoConstraints = false
            sn.widthAnchor.constraint(equalTo: senderNameLayouGuide.widthAnchor).isActive = true
            sn.bottomAnchor.constraint(equalTo: senderNameLayouGuide.bottomAnchor).isActive = true
            sn.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor).isActive = true
        }
    }
    
    var contentView: UIView? {
        didSet {
            guard let cv = contentView else { return /* could be reasonable to remove from superview old value */ }
            if let oldValue = oldValue { oldValue.removeFromSuperview() }
            addSubview(cv)
            cv.translatesAutoresizingMaskIntoConstraints = false
            contentLayoutGuide.heightAnchor.constraint(equalTo: cv.heightAnchor).isActive = true
            contentLayoutGuide.widthAnchor.constraint(equalTo: cv.widthAnchor).isActive = true
            contentLayoutGuide.topAnchor.constraint(equalTo: cv.topAnchor).isActive = true
        }
    }
    
    let layoutContentOffset: CGFloat = 4
    var leadingConstraints: [NSLayoutConstraint] {
        guard let cv = contentView else { return [] }
        return [
            contentLayoutGuide.leadingAnchor.constraint(equalTo: cv.leadingAnchor),
            centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor, constant: -layoutContentOffset)
        ]
    }
    
    var trailingConstraints: [NSLayoutConstraint] {
        guard let cv = contentView else { return [] }
        return [
            contentLayoutGuide.trailingAnchor.constraint(equalTo: cv.trailingAnchor),
            centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor, constant: layoutContentOffset)
        ]
    }
    
    var activeConstraints: [NSLayoutConstraint]?
    func activateConstraints(for direction: Direction) {
        activeConstraints?.deactivate()
        self.direction = direction
        
        switch direction {
        case .in:
            activeConstraints = leadingConstraints
        case .out:
            activeConstraints = trailingConstraints
        default: fatalError("Unsupported direction type.")
        }
        
        activeConstraints?.activate()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    var previousFrame: CGRect?
    func redrawBubbleLayer(for frame: CGRect) {
        guard let currentDirection = direction else { return }
        if previousFrame == frame { return }
        
        shapeLayer.path = drawPath(for: frame, direction: currentDirection).cgPath
        previousFrame = frame
    }
    
    private func drawPath(for frame: CGRect, direction: Direction) -> UIBezierPath {
        let path = SpeechBubblePath.draw(frame: frame)
        if direction == .in {
            path.apply(CGAffineTransform(scaleX: -1, y: 1))
            path.apply(CGAffineTransform(translationX: frame.width, y: 0))
        }

        return path
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redrawBubbleLayer(for: bounds)
    }
}
