//
//  AvatarState.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class AvatarState {
    private(set) var isEditing = false {
        didSet {
            isEditingChanged?()
        }
    }
    var wasChanged = false {
        didSet {
            changeStateChanged?()
        }
    }
    
    var isEditingChanged: (() -> Void)?
    var changeStateChanged: (() -> Void)?
    
    func startEditing() {
        wasChanged = true
        isEditing = true
    }
    
    func stopEditing() {
        isEditing = false
    }
    
    func reset() {
        stopEditing()
        wasChanged = false
    }
    
    private(set) var model: IProfileInfo!
    
    func configure(with model: IProfileInfo) {
        self.model = model
    }
}
