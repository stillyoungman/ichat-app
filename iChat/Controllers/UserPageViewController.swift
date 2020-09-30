//
//  UserPageViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 23.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit
import Photos

class UserPageViewController: PTViewController, IStoryboardViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print(editButton.frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ///3.2: не в одном из конструкторов нельзя получить доступ к значениям помеченным атрибутом @IBOutlet
        ///за инициализацию этих значений отвечает метод loadView(). Метод viewDidLoad гарантирует что все subview загружены
        //editButton.frame.toString().log()
    }
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        ///3.3
        editButton.frame.toString().log()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///3.4 возможно, причина в том что между viewDidLoad и viewDidAppear вызывается метод layoutSubviews()
        ///который располагает views исходя из ограничений наложенных на них
        editButton.frame.toString().log()
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
        #if EASTER_MODE
        avatarView.userName = "Constantine Nikolsky"
        userNameLabel.text = "Constantine Nikolsky"
        roleLabel.text = "Junior iOS developer"
        #else
        avatarView.userName = "Marina Dudarenko"
        userNameLabel.text = "Marina Dudarenko"
        roleLabel.text = "UI/UX designer, web-designer"
        #endif
        
        locationLabel.text = "Moscow, Russia"
        saveButton.backgroundColor = UIColor(hex: "#F6F6F6")
        saveButton.cornerRadius = 14
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
