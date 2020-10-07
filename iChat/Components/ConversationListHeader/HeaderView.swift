//
//  HeaderView.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UITableViewHeaderFooterView {
    lazy var lightEffect: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        return view
    }()
    lazy var darkEffect: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return view
    }()
    lazy var label: UILabel = UILabel()
    
    var leadingInset: CGFloat = 0 {
        didSet {
            label.frame = CGRect(x: leadingInset, y: 0, width: bounds.width, height: bounds.height)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    private func initialSetup() {

        addSubview(label)
    }
    
    private func setupAppearance(for model: HeaderModel) {
        backgroundView = model.mode == .night ? darkEffect : lightEffect
        label.textColor = model.theme.primaryText
    }
}

extension HeaderView: IConfigurable {
    func configure(with model: HeaderModel) {
        label.text = model.title
        setupAppearance(for: model)
    }
}

extension HeaderView {
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: leadingInset, y: 0, width: bounds.width, height: bounds.height)
    }
}
