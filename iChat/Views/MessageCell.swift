//
//  MessageCell.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    private let outputMessageColor = UIColor.init(hex: "#DCF7C5") ?? UIColor.systemGreen
    private let inputMessageColor = UIColor.init(hex: "#DFDFDF") ?? UIColor.systemGray
    
    private let bubbleMaxWidthMultiplier: CGFloat = 0.7
    
    lazy var bubble: BubbleView = {
        let bubble = BubbleView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubble)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        bubble.widthAnchor.constraint(lessThanOrEqualTo: marginGuide.widthAnchor,
            multiplier: bubbleMaxWidthMultiplier).isActive = true
        bubble.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        bubble.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        bubble.color = outputMessageColor
        
        return bubble
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .none
        textView.textContainerInset = .zero
        textView.font = .systemFont(ofSize: 16)
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .all
        textView.scrollsToTop = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    var incomingConstraints: [NSLayoutConstraint] {
        [ bubble.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor) ]
    }
    
    var outgoingConstraints: [NSLayoutConstraint] {
        [ bubble.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor) ]
    }
    
    var activeContraints = [NSLayoutConstraint]()
    func activateConstraints(for direction: Direction) {
        activeContraints.deactivate()
        activeContraints = direction == .in ? incomingConstraints : outgoingConstraints
        activeContraints.activate()
    }
    
    func setColor(for direction: Direction) {
        bubble.color = direction == .out ? outputMessageColor : inputMessageColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup(){
        selectionStyle = .none
        bubble.contentView = textView
        
        Utils.debug {
            backgroundColor = .systemPink
            contentView.backgroundColor = .yellow
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bubble.color = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension MessageCell: IConfigurable {
    
    func configure(with model: IMessage){
        let direction: Direction = model.isOutgoing ? .out : .in
        activateConstraints(for: direction)
        bubble.activateConstraints(for: direction)
        setColor(for: direction)
        
        if let textMessage = model as? TextMessage {
            textView.text = textMessage.text
        }
    }
}
