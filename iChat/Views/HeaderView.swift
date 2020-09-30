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
    lazy var effect: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
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
        backgroundView = effect
        addSubview(label)
    }
    
    func configure(with title: String) {
        label.text = title
    }
}

extension HeaderView {
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: leadingInset, y: 0, width: bounds.width, height: bounds.height)
    }
}
