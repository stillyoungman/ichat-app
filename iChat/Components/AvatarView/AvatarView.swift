//
//  AvatarView.swift
//  iChat
//
//  Created by Constantine Nikolsky on 23.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

@IBDesignable class AvatarView: UIView, INibView, IConfigurable {
    private let fontSizeMultiplier = CGFloat(0.6)
    private let maxFontSize = CGFloat(150)
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private lazy var userInitialsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(hex: "#363738") ?? .black
        return label
    }()
    private var userInitials: String? {
        didSet {
            userInitialsLabel.text = userInitials
        }
    }
    
    func configure(with model: IAvatarViewModel) {
        image = model.image
        userName = model.username
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            if image == nil {
                setupStyleForAppearanceWithoutImage()
            } else {
                setupStyleForAppearanceWithImage()
            }
        }
    }
    private var userName: String? {
        didSet {
            guard let userName = userName, !userName.isEmpty else { return }
            let userNameChunks = userName.split(separator: " ").map( { Array($0) })
            userInitials = "\(String(userNameChunks[0][0]).uppercased())\(userNameChunks.count > 1 && userNameChunks[1].count > 1  ? String(userNameChunks[1][0]).uppercased() : "")"
        }
    }
    private let emptyThumbnailColor = UIColor(hex: "E4E82B") ?? .yellow
    var delegate: AvatarViewDelegate?
    
    private func baseSetup(){
        cornerRadius = bounds.width / 2
    }
    
    private func addSubviews(){
        addSubview(userInitialsLabel)
        addSubview(imageView)
    }
    
    private func setupStyleForAppearanceWithoutImage(){
        backgroundColor = emptyThumbnailColor
        userInitialsLabel.isHidden = false
        imageView.isHidden = true
    }
    
    private func setupStyleForAppearanceWithImage(){
        backgroundColor = .none
        userInitialsLabel.isHidden = true
        imageView.isHidden = false
    }
}

// MARK: - UIView
extension AvatarView {
    override func awakeFromNib() {
        super.awakeFromNib()
        baseSetup()
        addSubviews()
        setupStyleForAppearanceWithoutImage()
        addTapGestureRecognizer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        baseSetup()
        imageView.frame = bounds
        
        userInitialsLabel.frame = bounds
        
        userInitialsLabel.fitFontForSize(CGSize(width: bounds.width * fontSizeMultiplier,
                                                height: bounds.height * fontSizeMultiplier),
                                         maxFontSize: maxFontSize)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        baseSetup()
        addSubviews()
        setupStyleForAppearanceWithoutImage()
        userName = "Constantine Nikolsky"
    }
}

// MARK: - UIGestureRecognizerDelegate
extension AvatarView: UIGestureRecognizerDelegate {
    private func addTapGestureRecognizer(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tap.delegate = self
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        delegate?.viewDidTapped()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touchPath.contains(touch.location(in: self))
    }
    
    private var touchPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2)
    }
}
