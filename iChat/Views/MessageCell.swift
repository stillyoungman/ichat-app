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
    
    lazy var messageBubble: MessageBuble = MessageBuble()
    
    var activeContraints = [NSLayoutConstraint]()
    
    private func addSubviews(){
        addSubview(messageBubble)
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        messageBubble.pinEdges(to: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NSLayoutConstraint.deactivate(activeContraints)
        print("1-\(messageBubble.constraints.count)")
        messageBubble.reset()
        print("2-\(messageBubble.constraints.count)")
        
    }
}

extension MessageCell: ConfigurableView {
    typealias ConfigurationModel = MessageModel
    
    func configure(with model: MessageModel) {
        self.messageBubble.configure(model)
        
        activeContraints =
            [
                messageBubble.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
                messageBubble.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
                messageBubble.leadingAnchor.constraint(equalTo: leadingAnchor),
                messageBubble.topAnchor.constraint(equalTo: topAnchor)
        ]
        
        NSLayoutConstraint.activate(activeContraints)
    }
}

//UIEdgeInsets(top: 10, left: 10, bottom: 70, right: 70) - 21 lines

class MessageBuble: UIView {
    //    private static let bubbleImage: UIImage = #imageLiteral(resourceName: "messageBubble")
    //        .resizableImage(withCapInsets:
    //            UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30),
    //                        resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
    
    var model: MessageModel?
    
    private static let bubbleImage: UIImage = #imageLiteral(resourceName: "messageBubble")
        .resizableImage(withCapInsets:
            UIEdgeInsets(top: 10, left: 10, bottom: 70, right: 70),
                        resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
    
    private lazy var messageBuble: UIImageView = UIImageView(image: MessageBuble.bubbleImage )
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        UIView.performWithoutAnimation({ () -> Void in // fixes iOS 8 blinking when cell appears
            textView.backgroundColor = UIColor.clear
        })
        textView.isEditable = false
        textView.isSelectable = false
        textView.dataDetectorTypes = .all
        textView.scrollsToTop = false
        textView.isScrollEnabled = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isExclusiveTouch = true
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.systemFont(ofSize: fontSize)
        return textView
    }()
    
    var attributedText: NSAttributedString?
    
    private let outputMessageColor = UIColor.init(hex: "#DCF7C5") ?? UIColor.systemGreen
    private let inputMessageColor = UIColor.init(hex: "#DFDFDF") ?? UIColor.systemGray
    let outerBubbleVerticalSpace: CGFloat = 20
    let innerBubbleVerticalSpace: CGFloat = 12
    let innerBubbleHorizontalSpace: CGFloat = 15
    let lineHeight: CGFloat = 19
    let fontSize: CGFloat = 16
    let widthMultiplier: CGFloat = 0.7
    let sidePadding: CGFloat = 10
    
    var lineSpacing: CGFloat { (lineHeight - fontSize) / 2 }
    var height: CGFloat { lineHeight * CGFloat(linesCount) }
    var availableWidth: CGFloat { messageBuble.frame.width - innerBubbleVerticalSpace }
    
    var linesCount: Int {
        if availableWidth <= 0 {
            return 0
            
        }
        guard let text = attributedText else { return 0 }
        
        let height = text.height(containerWidth: availableWidth)
        if height < lineHeight { return 1 }
        let hasReminder = height.truncatingRemainder(dividingBy: lineHeight) == 0
        let lines = Int(height / lineHeight)
        return hasReminder ? lines + 1 : lines
    }
    
    var appliedContraints = [NSLayoutConstraint]()
    
    var leadingSideConstraints: [NSLayoutConstraint] {
        [
            messageBuble.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier),
            messageBuble.heightAnchor.constraint(equalToConstant: height),
            messageBuble.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageBuble.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sidePadding)
        ]
    }
    
    var trailingSideConstraints: [NSLayoutConstraint] {
        [
            messageBuble.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier),
            messageBuble.heightAnchor.constraint(equalToConstant: height),
            messageBuble.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageBuble.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sidePadding)
        ]
    }
    
    func heightForLines(_ count: Int) -> CGFloat {
        trace()
        "\(count) -> \(CGFloat(lineHeight * CGFloat(count) + innerBubbleVerticalSpace))".log()
        return CGFloat(lineHeight * CGFloat(count) + innerBubbleVerticalSpace)
    }
    
    func setupMessageText(text: String?){
        guard let text = text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        attributeString.addAttributes(attributes, range:  NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width:sidePadding + frame.width * widthMultiplier , height: height)
    }
    
//    override var intrinsicContentSize: CGSize {
//        print(CGSize(width: sidePadding + frame.width * widthMultiplier,
//            height: height + innerBubbleVerticalSpace + outerBubbleVerticalSpace))
//        print(height)
//        return CGSize(width: sidePadding + frame.width * widthMultiplier,
//                      height: height + innerBubbleVerticalSpace + outerBubbleVerticalSpace)
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func reset() {
        NSLayoutConstraint.deactivate(appliedContraints)
        appliedContraints = []
        attributedText = nil
        textView.text = ""
        backgroundColor = .none
        messageBuble.image = nil
    }
    
    func configure(_ model: MessageModel) {
        self.model = model
        setupMessageText(text: model.text)
        
        
        if model.isOutput {
            
            messageBuble.tintColor = outputMessageColor
            messageBuble.image = MessageBuble.bubbleImage
        } else {
            
            messageBuble.tintColor = inputMessageColor
            messageBuble.image = MessageBuble.bubbleImage.withHorizontallyFlippedOrientation()
        }
        appliedContraints =  model.isOutput ? trailingSideConstraints : leadingSideConstraints
        NSLayoutConstraint.activate(appliedContraints)
    }
    
    func activateConstraints(){
        guard let model = model else {
            return
        }
        appliedContraints =  model.isOutput ? trailingSideConstraints : leadingSideConstraints
    }
    
    func initialSetup(){
        messageBuble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageBuble)
        
        //        NSLayoutConstraint.activate(trailingSideConstraints)
        
        
        //        messageBuble.tintColor = UIColor.init(hex: "#DCF7C5")!
    }
    
    
}
