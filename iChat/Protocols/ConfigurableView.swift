//
//  ConfigurableView.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
