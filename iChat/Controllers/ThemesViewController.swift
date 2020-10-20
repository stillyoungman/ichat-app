//
//  ThemesViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 08.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ThemesViewController: UIViewController, IStoryboardViewController {
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private var labels: [UILabel]!
    
    @IBAction private func handleThemeChange(_ sender: UIButton) {
        guard let mode = ThemeMode(rawValue: sender.tag) else {
            fatalError("Unsopported ThemeMode")
        }
        
        if mode == themeManager.mode { return }
        desturctAppearance()
        
        self.themeManager.mode = mode
        updateTheme()
        
        DQ.main.async {
            if let action = self.themeChanged {
                 action(mode)
             }
            self.delegate?.themeChanged(mode)
        }
        
        setupAppearance()
    }
    
    weak var delegate: ThemesPickerDelegate?
    var themeChanged: ((ThemeMode) -> Void)?
    
    private var theme: ThemesViewControllerTheme!
    private var container: IServiceResolver!
    private var themeManager: IThemeManager!
    func setupDependencies(with container: IServiceResolver) {
        self.container = container
        self.themeManager = container.resolve(for: IThemeManager.self)
        updateTheme()
    }
    
    private func updateTheme() {
        self.theme = theme(for: themeManager.mode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setupAppearance()
    }
    
    private func configureNavigation() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupAppearance() {
        if let labels = self.labels {
            for label in labels {
                label.textColor = theme.font
            }
        }
        view.backgroundColor = theme.backbournd
        
        if let notSelectedStroke = theme.notSelectedStroke {
            for btn in buttons {
                btn.setStroke(notSelectedStroke, 1)
            }
        }
        
        let btn = buttons.filter { $0.tag == themeManager.mode.rawValue }.first!
        btn.setStroke(theme.selectionStroke)
    }
    
    private func desturctAppearance() {
        for btn in buttons {
            btn.setStroke(.clear, 0, 0)
        }
    }
}

fileprivate extension UIButton {
    func setStroke(_ color: UIColor, _ borderWidth: CGFloat = 2, _ cornerRadius: CGFloat = 14) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = cornerRadius > 0
    }
}

struct ThemesViewControllerTheme {
    let font: UIColor
    let backbournd: UIColor
    let selectionStroke: UIColor
    let notSelectedStroke: UIColor?
}

extension ThemesViewController: ISupportTheme {
    typealias Theme = ThemesViewControllerTheme
    
    private var classicTheme: ThemesViewControllerTheme {
        ThemesViewControllerTheme(font: .white,
                                  backbournd: UIColor(hex: "#193661")!,
                                  selectionStroke: UIColor(hex: "#007AFF")!,
                                  notSelectedStroke: nil)
    }
    
    private var dayTheme: ThemesViewControllerTheme {
        ThemesViewControllerTheme(font: .black,
                                  backbournd: .white,
                                  selectionStroke: UIColor(hex: "#007AFF")!,
                                  notSelectedStroke: .gray)
    }
    
    private var nightTheme: ThemesViewControllerTheme {
        ThemesViewControllerTheme(font: .white,
                                  backbournd: .black,
                                  selectionStroke: .white,
                                  notSelectedStroke: .lightGray)
    }
    
    func theme(for mode: ThemeMode) -> ThemesViewControllerTheme {
        switch mode {
        case .classic: return classicTheme
        case .day: return dayTheme
        case .night: return nightTheme
        }
    }
}

protocol ThemesPickerDelegate: class {
    func themeChanged(_ mode: ThemeMode)
}

protocol ISupportTheme {
    associatedtype Theme
    
    func theme(for mode: ThemeMode) -> Theme
}
