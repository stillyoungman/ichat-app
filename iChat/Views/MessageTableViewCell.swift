//
//  MessageTableViewCell.swift
//  iChat
//
//  Created by Constantine Nikolsky on 01.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, INibView {
    @IBOutlet weak var bubbleView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var lineSpacing: CGFloat { (lineHeight - fontSize) / 2 }
    
    private let outputMessageColor = UIColor.init(hex: "#DCF7C5") ?? UIColor.systemGreen
    private let inputMessageColor = UIColor.init(hex: "#DFDFDF") ?? UIColor.systemGray
    
    private var sourceImage: UIImage {
        #imageLiteral(resourceName: "messageBubble")
               .resizableImage(withCapInsets:
                   UIEdgeInsets(top: 10, left: 10, bottom: 70, right: 70),
                               resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
    }
    
    let outerBubbleVerticalSpace: CGFloat = 20
    let innerBubbleVerticalSpace: CGFloat = 12
    let innerBubbleHorizontalSpace: CGFloat = 15
    let lineHeight: CGFloat = 19
    let fontSize: CGFloat = 16
    let widthMultiplier: CGFloat = 0.7
    let sidePadding: CGFloat = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        bubbleView.image = sourceImage
        
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(_ model: MessageModel) {

        if model.isOutput {
            
            bubbleView.tintColor = outputMessageColor
            bubbleView.image = sourceImage

        } else {
            bubbleView.tintColor = inputMessageColor
            bubbleView.image = sourceImage.withHorizontallyFlippedOrientation()
        }
        setupMessageText(model.text)
    }
    
    func setupMessageText(_ text: String?){
        guard let text = text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.paragraphStyle: style
        ]
        
        attributeString.addAttributes(attributes, range:  NSMakeRange(0, attributeString.length))
        self.textView.attributedText = attributeString
    }
    
}
