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
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    private var model: IProfileInfo!
    private var container: IServiceResolver!
    
    func setupDependencies(with container: IServiceResolver) {
        self.container = container
    }
    
    func setModel(_ model: IProfileInfo) {
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        configure(with: model)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func editTouchUpInside(_ sender: UIButton) {
        presentAlertViewController()
    }
    
    private func presentAlertViewController(){
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
    
    private func initialSetup() {
        saveButton.backgroundColor = UIColor(hex: "#F6F6F6")
        saveButton.cornerRadius = 14
    }
    
    func configure(with model: IProfileInfo) {
        avatarView.configure(with: model)
        userNameLabel.text = model.username
        roleLabel.text = model.description
        locationLabel.text = model.location
    }
}

extension UserPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            avatarView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}
