//
//  ChangeType.swift
//  iChat
//
//  Created by Constantine Nikolsky on 04.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

enum Change<T> {
    case created(T)
    case updated(T)
    case deleted(T)
    
    var value: T {
        switch self {
        case .deleted(let v): return v
        case .created(let v): return v
        case .updated(let v): return v
        }
    }
    
    var isDeleted: Bool {
        switch self {
        case .deleted: return true
        default: return false
        }
    }
    
    var isUpdated: Bool {
        switch self {
        case .updated: return true
        default: return false
        }
    }
    
    var isCreated: Bool {
        switch self {
        case .created: return true
        default: return false
        }
    }

}
