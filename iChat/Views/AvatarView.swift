//
//  AvatarView.swift
//  iChat
//
//  Created by Constantine Nikolsky on 23.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit


@IBDesignable class AvatarView: PTView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let userInitialsLabel: UILabel = {
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
    private var touchPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: bounds.width, height: bounds.width))
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
    var userName: String? {
        didSet {
            guard let userName = userName, !userName.isEmpty else { return }
            let userNameChunks = userName.split(separator: " ").map( { Array($0) })
            userInitials = "\(String(userNameChunks[0][0]).uppercased())\(userNameChunks.count > 1 && userNameChunks[1].count > 1  ? String(userNameChunks[1][0]).uppercased() : "")"
        }
    }
    var emptyThumbnailColor = UIColor(hex: "E4E82B") ?? .yellow
    var delegate: AvatarViewDelegate?
}

extension AvatarView {
    private func initialSetup(){
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        addSubviews()
        setupStyleForAppearanceWithoutImage()
        addTapGestureRecognizer()
        #if EASTER_MODE
        image = UIImage(named: "droid")
        #endif
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialSetup()
        addSubviews()
        setupStyleForAppearanceWithoutImage()
        userName = "Constantine Nikolsky"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        
        userInitialsLabel.frame = bounds
        userInitialsLabel.fitFontForSize(CGSize(width: bounds.width * 0.65, height: bounds.height * 0.65), maxFontSize: 150)
    }
}

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
}
