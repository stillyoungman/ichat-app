//
//  GuidedViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 22.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class GuidedViewController: UIViewController {
    lazy var wrapper: UILayoutGuide = {
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)
        return guide
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subsribeForKeyboardNotifications()
    }
    
    var currentLayoutConstraints: [NSLayoutConstraint] = []
    
    lazy var defaultLayoutConstraints: [NSLayoutConstraint] = {
       [
            self.wrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.wrapper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.wrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.wrapper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }()
    
    func shiftedConstraints(by value: CGFloat) -> [NSLayoutConstraint] {
        [
            self.wrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.wrapper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.wrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -value),
            self.wrapper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -value)
        ]
    }
    
    open var shiftMultiplier: CGFloat {
        return 1
    }
}

// MARK: - Keyboard show/dismiss handlers
extension GuidedViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            currentLayoutConstraints.deactivate()
            currentLayoutConstraints = shiftedConstraints(by: keyboardSize.height * shiftMultiplier)
            currentLayoutConstraints.activate()
            self.view.needsUpdateConstraints()
            UIView.animate(withDuration: duration + 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        currentLayoutConstraints.deactivate()
        currentLayoutConstraints = defaultLayoutConstraints
        currentLayoutConstraints.activate()
        self.view.needsUpdateConstraints()
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func subsribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unsubsribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
