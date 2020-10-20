//
//  UserPageViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 23.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit
import Photos

// TODO: Handle avatar save
// TODO: Add remove image
class UserPageViewController: UIViewController, IStoryboardViewController, IConfigurable {
    
    lazy var avatarView: AvatarView = {
        let a = AvatarView.fromNib()
        a.isUserInteractionEnabled = false
        return a
    }()
    lazy var editAvatarPictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.addTarget(self, action: #selector(editTouchUpInside(_:)), for: .touchUpInside)
        return button
    }()
    lazy var userName: TextField = {
        let tf = TextField()
        tf.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        tf.textAlignment = .center
        return tf
    }()
    lazy var location: TextField = {
        let tf = TextField()
        tf.font = UIFont.systemFont(ofSize: 16, weight: .light)
        tf.textAlignment = .center
        return tf
    }()
    lazy var about: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16, weight: .light)
        tv.textAlignment = .center
        tv.backgroundColor = .clear
        return tv
    }()
    let locationAndAboutWrapper = UIView()
    
    let buttonContentInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    lazy var operationSave: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Operation", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        button.contentEdgeInsets = buttonContentInsets
        button.addTarget(self, action: #selector(saveWithOperation(_:)), for: .touchUpInside)
        return button
    }()
    lazy var gcdSave: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GCD", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        button.contentEdgeInsets = buttonContentInsets
        button.addTarget(self, action: #selector(saveWithGCD(_:)), for: .touchUpInside)
        return button
    }()
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(gcdSave)
        stackView.addArrangedSubview(operationSave)
        stackView.spacing = 40
        return stackView
    }()
    
    lazy var wrapper: UILayoutGuide = {
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)
        return guide
    }()
    
    var profile: ProfileInfo {
        ProfileInfo(username: userName.text ?? "",
                    about: about.text,
                    location: location.text ?? "",
                    image: avatarView.image)
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
    
    func shiftedToTopConstraints(by value: CGFloat) -> [NSLayoutConstraint] {
        [
            self.wrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.wrapper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.wrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -value),
            self.wrapper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -value)
        ]
    }
    
    lazy var backButton = UIBarButtonItem(title: "Back",
                                     style: UIBarButtonItem.Style.plain,
                                     target: self, action: #selector(back(sender:)))
    lazy var editProfileButton = UIBarButtonItem(title: "Edit profile",
                                            style: UIBarButtonItem.Style.plain,
                                            target: self, action: #selector(startEditing(sender:)))
    lazy var resetButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Cancel",
                                  style: UIBarButtonItem.Style.plain,
                                  target: self, action: #selector(reset(sender:)))
        btn.tintColor = .red
        return btn
    }()
    
    private var model: IProfileInfo!
    private var container: IServiceResolver!
    private var theme: IThemeProvider!
    
    fileprivate lazy var state: AvatarState = {
        let state = AvatarState()
        state.isEditingChanged = isEditingChanged
        state.changeStateChanged = changingStateWasChanged
        return state
    }()
    
    func setupDependencies(with container: IServiceResolver) {
        self.container = container
        self.theme = container.resolve(for: IThemeProvider.self)
    }
    
    func setModel(_ model: IProfileInfo) {
        self.model = model
    }
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        initialSetup()
        configure(with: model)
        setupConstraints()
        
        subsribeForKeyboardNotifications()
        
        navigationItem.rightBarButtonItem = editProfileButton
    }
    
    deinit {
        unsubsribe()
    }
    
    private func initialSetup() {
        view.backgroundColor = theme.value.background
        
        let tintColor = theme.mode == .night ? UIColor(hex: "#0A84FF") : UIColor(hex: "007AFF")
        let buttonBackgroundColor = theme.mode == .night ? UIColor(hex: "#1B1B1B") : UIColor(hex: "#F6F6F6")
        operationSave.backgroundColor = buttonBackgroundColor
        operationSave.tintColor = tintColor
        operationSave.cornerRadius = 14
        gcdSave.backgroundColor = buttonBackgroundColor
        gcdSave.tintColor = tintColor
        gcdSave.cornerRadius = 14
        
        editAvatarPictureButton.tintColor = tintColor
        
        userName.textColor = theme.value.primaryText
        about.textColor = theme.value.primaryText
        location.textColor = theme.value.primaryText
        
        userName.attributedPlaceholder = NSAttributedString(string: "Your name", attributes: [NSAttributedString.Key.foregroundColor: theme.value.secondaryText])
        location.attributedPlaceholder = NSAttributedString(string: "Location.", attributes: [NSAttributedString.Key.foregroundColor: theme.value.secondaryText])

        userName.padding = UIEdgeInsets(top: 4, left: 7, bottom: 4, right: 7)
        
        hideKeyboardWhenTappedAround()
        isEditingChanged()
        changingStateWasChanged()
    }
    
    func configure(with model: IProfileInfo) {
        avatarView.configure(with: model)
        userName.text = model.username
        about.text = model.about
        location.text = model.location
        
        state.configure(with: model)
    }
    
// MARK: - State change handlers
    func isEditingChanged() {
        if state.isEditing {
            userName.isEnabled = true
            about.isEditable = true
            about.isSelectable = true
            location.isEnabled = true
            editProfileButton.isEnabled = false
            
            userName.backgroundColor = UIColor(hex: "#74b9ff")!.withAlphaComponent(0.1)
            locationAndAboutWrapper.backgroundColor = UIColor(hex: "#74b9ff")!.withAlphaComponent(0.1)

            userName.addBorder(borderColor: UIColor.white.withAlphaComponent(0.5),
                               borderWith: 2,
                               borderCornerRadius: 10)
            locationAndAboutWrapper.addBorder(borderColor: UIColor.white.withAlphaComponent(0.5),
                                              borderWith: 1,
                                              borderCornerRadius: 10)
            locationAndAboutWrapper.cornerRadius = 10
            
            navigationItem.leftBarButtonItem = resetButton
        } else {
            userName.isEnabled = false
            about.isEditable = false
            about.isSelectable = false
            location.isEnabled = false
            editProfileButton.isEnabled = true
            
            userName.backgroundColor = .clear
            locationAndAboutWrapper.backgroundColor = .clear
            
            userName.removeBorder()
            locationAndAboutWrapper.removeBorder()
            
            navigationItem.leftBarButtonItem = backButton
        }
    }

    func changingStateWasChanged() {
        navigationItem.leftBarButtonItem = state.wasChanged ? resetButton : backButton
        navigationItem.leftBarButtonItem?.isEnabled = true
        
        if state.wasChanged {
            gcdSave.isEnabled = true
            operationSave.isEnabled = true
        } else {
            gcdSave.isEnabled = false
            operationSave.isEnabled = false
        }
        
        if #available(iOS 13.0, *) {
            //prevent from accidental close
            self.isModalInPresentation = state.wasChanged
        }
    }
    
    // MARK: - Handlers
    var profileHasBeenChanged: ((IProfileInfo) -> Void)?
    
    @objc func back(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func reset(sender: UIBarButtonItem) {
        self.configure(with: state.model)
        state.reset()
    }
    
    @objc func startEditing(sender: UIBarButtonItem) {
        state.startEditing()
    }
    
    @objc func editTouchUpInside(_ sender: UIButton) {
        presentAlertViewController()
    }
    
    func enableUIControls(_ value: Bool) {
        gcdSave.isEnabled = value
        operationSave.isEnabled = value
        editProfileButton.isEnabled = value
        navigationItem.leftBarButtonItem?.isEnabled = value
    }
    
    func presentErrorAlert(_ retryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: "Profile was updated", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel) { _ in alert.dismiss(animated: true) }
        let retry = UIAlertAction(title: "Retry", style: .default) { _ in retryAction() }
        alert.addAction(ok)
        alert.addAction(retry)
        present(alert, animated: true)
    }
    
    func presentSuccessAlert() {
        let alert = UIAlertController(title: nil, message: "Profile was updated", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in alert.dismiss(animated: true) }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func performSave(with manager: IPersistenceManager) {
        let _profile = profile
        enableUIControls(false)
        
        UserProfileManager.shared.save(manager, profile: _profile) { [weak self] err in
            if err != nil {
                DQ.main.async {
                    self?.enableUIControls(true)
                    self?.presentErrorAlert { self?.performSave(with: manager) }
                }
            } else {
                DQ.main.async {
                    self?.profileHasBeenChanged?(_profile)
                    self?.state.configure(with: _profile)
                    self?.state.reset()
                    self?.presentSuccessAlert()
                }
            }
        }
    }
    
    @objc func saveWithGCD(_ sender: UIButton) {
        performSave(with: GPersistenceManager())
    }
    
    @objc func saveWithOperation(_ sender: UIButton) {
        performSave(with: OPersistenceManager())
    }
}

// MARK: - Changing of avatar
extension UserPageViewController {
    private func presentAlertViewController() {
        let vc = UIAlertController(title: nil, message: "Choose source of picture", preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default ) { _ in
            vc.dismiss(animated: true)
            self.presentCameraImagePicker()
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
            vc.dismiss(animated: true)
            self.presentLibraryPhotosImagePicker()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in vc.dismiss(animated: true) }
        vc.addAction(takePhoto)
        vc.addAction(photoLibrary)
        vc.addAction(cancel)
        
        present(vc, animated: true)
    }
    
    private func presentLibraryPhotosImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func presentCameraImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - Keyboard show/dismiss handlers
extension UserPageViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            currentLayoutConstraints.deactivate()
            currentLayoutConstraints = shiftedToTopConstraints(by: keyboardSize.height * shiftMultiplier)
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
    
    var shiftMultiplier: CGFloat {
        if userName.isFirstResponder {
            return 0.4
        } else if location.isFirstResponder {
            return 0.75
        } else if about.isFirstResponder {
            return 0.9
        }
        return 1
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

extension UserPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarView.image = image
            state.wasChanged = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}
