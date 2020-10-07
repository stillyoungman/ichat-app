//
//  ThemeManager.swift
//  iChat
//
//  Created by Constantine Nikolsky on 08.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager: IThemeManager {
    let modeKey = "themeMode"
    
    var mode: ThemeMode {
        didSet {
            UserDefaults.standard.set(String(mode.rawValue), forKey: modeKey)
        }
    }
    var value: IApplicationTheme {
        switch mode {
        case .classic: return classic
        case .day: return day
        case .night: return night
        }
    }
    
    private init() {
        mode = ThemeMode.init(rawValue: UserDefaults.standard.integer(forKey: modeKey)) ?? .classic
    }
    
    static let shared = ThemeManager()
}

extension ThemeManager {
    var classic: ApplicationTheme {
        ApplicationTheme(incomingBubble: UIColor.init(hex: "#DFDFDF")!,
                         outgoingBubble: UIColor.init(hex: "#DCF7C5")!,
                         primaryText: .black,
                         secondaryText: UIColor.init(hex: "#3C3C43")!,
                         background: .white,
                         titnColor: .gray)
    }
    
    var day: ApplicationTheme {
        var t = ApplicationTheme(incomingBubble: UIColor.init(hex: "#DFDFDF")!,
        outgoingBubble: UIColor.init(hex: "#4389F9")!,
        primaryText: .black,
        secondaryText: UIColor.init(hex: "#3C3C43")!,
        background: .white,
        titnColor: .gray)
        t.outgointText = .white
        return t
    }
    
    var night: ApplicationTheme {
    ApplicationTheme(incomingBubble: UIColor.init(hex: "#2E2E2E")!,
                     outgoingBubble: UIColor.init(hex: "#5C5C5C")!,
                     primaryText: .white,
                     secondaryText: .white,
                     background: .black,
                     titnColor: .white)
    }
}

protocol IApplicationTheme {
    var incomingBubble: UIColor { get }
    var outgoingBubble: UIColor { get }
    var outgointText: UIColor? { get }
    var primaryText: UIColor { get }
    var secondaryText: UIColor { get }
    var background: UIColor { get }
    var titnColor: UIColor { get }
}

struct ApplicationTheme: IApplicationTheme {
    var incomingBubble: UIColor
    var outgoingBubble: UIColor
    var outgointText: UIColor? = nil
    var primaryText: UIColor
    var secondaryText: UIColor
    var background: UIColor
    var titnColor: UIColor
    
}

protocol IThemeManager: IThemeProvider {
    var mode: ThemeMode { get set }
}

protocol IThemeProvider {
    var mode: ThemeMode { get }
    var value: IApplicationTheme { get }
}
