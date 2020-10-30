//
//  ConversationCell.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    static var _appContext: ApplicationContext?
    
    private(set) var model: Channel!
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var rightChevronView: UIView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var lastMessage: UILabel!
    lazy var chevron: UIButton = {
        var b = UIButton(type: .system)
        b.tintColor = .milkGray
        b.setImage(#imageLiteral(resourceName: "right.png"), for: .normal)
        b.backgroundColor = .none
        b.imageView?.contentMode = .scaleAspectFit
        return b
    }()
    
    private func setBackroundColor(_ selected: Bool = false) {
        backgroundColor = selected
            ? ConversationCell.selectedBackroundColor
            : isMineConversation ? ConversationCell.mineConversationBackroundColor : ConversationCell.defaultBackroundColor
    }
    
    var isMineConversation: Bool {
        model.ownerId == ConversationCell.appContext.deviceUid
    }
    
    private static let lastMessageFontSize: CGFloat = 13
    private static let lineSpacing: CGFloat = 2.5 // lastMessageFontSize + lineSpacing * 2 = 18-required line height
    private static let lastMessageDefaultFont = UIFont.systemFont(ofSize: lastMessageFontSize)
    private static let noMessagesFont = UIFont(name: "Arial Rounded MT Bold", size: lastMessageFontSize)
    private static let selectedBackroundColor = UIColor.milkGray.withAlphaComponent(0.03)
    private static let mineConversationBackroundColor = UIColor.softYellow
    private static let defaultBackroundColor = UIColor.clear
    
    private func initialSetup() {
        rightChevronView.addSubview(chevron)
        selectionStyle = .none
    }
    
    private func reset() {
        name.text = nil
        time.text = nil
        lastMessage.text = nil
        lastMessage.attributedText = nil
        backgroundColor = .clear
        lastMessage.font = ConversationCell.lastMessageDefaultFont
        lastMessage.textColor = UIColor.milkGray
    }
    
    public func apply(_ theme: IApplicationTheme, for mode: ThemeMode) {
        if mode == .night {
            chevron.tintColor = theme.titnColor
        }
        
        name.textColor = theme.primaryText
        time.textColor = theme.secondaryText
        lastMessage.textColor = theme.secondaryText
    }
}

// MARK: - UITableViewCell
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if animated {
            UIView.animate(withDuration: 0.1, delay: 1.0, options: [], animations: {
                
            }, completion: nil)
        } else {
            self.setBackroundColor(selected)
        }
    }
}

// MARK: - IConfigurable
extension ConversationCell: IConfigurable {
    typealias ConfigurationModel = Channel
    
    func configure(with model: Channel) {
        self.model = model
        self.name.text = model.name
        setBackroundColor()
        
        if model.hasNoMessages {
            self.lastMessage.text = "No messages yet"
            self.lastMessage.font = ConversationCell.noMessagesFont
            self.lastMessage.textColor = .black
        } else {
            if let lastMessage = model.lastMessage {
                self.lastMessage.attributedText = configureLastMessageText(lastMessage)
            }
            if let lastActivity = model.lastActivity {
                time.text = lastActivity.isYesterdayOrEarlier
                    ? lastActivity.toDaysAndMonthsString()
                    : lastActivity.toHoursAndMinutesString()
            }
        }
        
        avatarView.configure(with: AvatarViewModel(username: model.name, image: nil))
        
    }
    
    func setModel(_ model: Channel) {
        self.model = model
    }
    
    private func configureLastMessageText(_ text: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingTail
        style.lineSpacing = ConversationCell.lineSpacing
        
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                     value: style, range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
}
