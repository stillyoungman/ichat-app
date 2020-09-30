//
//  ConversationCell.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, INibView {
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var rightChevronView: UIView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var lastMessage: UILabel!
    lazy var chevron: UIButton = {
        var b = UIButton(type: .custom)
        b.tintColor = .milkGray
        b.setImage(#imageLiteral(resourceName: "right.png"), for: .normal)
        b.backgroundColor = .none
        b.imageView?.contentMode = .scaleAspectFit
        return b
    }()
    
    private let lastMessageFontSize: CGFloat = 13
    private let lineSpacing: CGFloat = 2.5 // lastMessageFontSize + lineSpacing * 2 = 18-required line height
    lazy var lastMessageDefaultFont = UIFont.systemFont(ofSize: lastMessageFontSize)
    lazy var noMessagesFont = UIFont.init(name: "Arial Rounded MT Bold", size: lastMessageFontSize)
    let selectedBackroundColor = UIColor.milkGray.withAlphaComponent(0.03)
    
    private func initialSetup(){
        rightChevronView.addSubview(chevron)
        selectionStyle = .none
    }
    
    private func reset() {
        name.text = nil
        time.text = nil
        lastMessage.text = nil
        lastMessage.attributedText = nil
        backgroundColor = .clear
        lastMessage.font = lastMessageDefaultFont
        lastMessage.textColor = UIColor.milkGray
        avatarView.userName = nil
    }
}

extension ConversationCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        chevron.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        chevron.center = CGPoint(x: rightChevronView.bounds.width / 2, y: rightChevronView.bounds.height / 2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        if(animated) {
            UIView.animate(withDuration: 0.1, delay: 0.0, options:[], animations: {
                self.backgroundColor = selected ? self.selectedBackroundColor : self.backgroundColor
            }, completion:nil)
        } else {
            self.backgroundColor = selected ? selectedBackroundColor : self.backgroundColor
        }
    }
}

extension ConversationCell: ConfigurableView {
    typealias ConfigurationModel = IConversationInfo
    
    func configure(with model: IConversationInfo) {
        self.name.text = model.name
        if model.hasNoMessages {
            self.lastMessage.text = "No messages yet"
            self.lastMessage.font = noMessagesFont
            self.lastMessage.textColor = .black
        } else {
            self.lastMessage.attributedText = configureLastMessageText(model.message)
            time.text = model.date.isYesterdayOrEarlier
                ? model.date.toDaysAndMonthsString()
                : model.date.toHoursAndMinutesString()
            if model.hasUnreadMessages { self.lastMessage.font = lastMessageDefaultFont.bold }
        }
        
        avatarView.userName = model.name
        
        if model.isOnline {
            backgroundColor = .softYellow
        }
    }
    
    func configureLastMessageText(_ text: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingTail
        style.lineSpacing = lineSpacing
        
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
}
