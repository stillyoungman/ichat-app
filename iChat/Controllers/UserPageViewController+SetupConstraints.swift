//
//  UserPageViewController+SetupConstraints.swift
//  iChat
//
//  Created by Constantine Nikolsky on 21.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

extension UserPageViewController {
    //потому что для Apple так сложно подвезти UILayoutGuid в IB :((
    func setupConstraints() {
        currentLayoutConstraints = defaultLayoutConstraints
        currentLayoutConstraints.activate()
        
        view.addSubview(avatarView)
        view.addSubview(editAvatarPictureButton)
        view.addSubview(userName)
        view.addSubview(buttonsStackView)
        view.addSubview(locationAndAboutWrapper)
        
        locationAndAboutWrapper.addSubview(location)
        locationAndAboutWrapper.addSubview(about)
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        [
            avatarView.aspectRatio(1),
            avatarView.heightAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.6),
            avatarView.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 25),
            avatarView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor, constant: 0)
        ].activate()
        
        editAvatarPictureButton.translatesAutoresizingMaskIntoConstraints = false
        [
            editAvatarPictureButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            editAvatarPictureButton.firstBaselineAnchor.constraint(equalTo: avatarView.bottomAnchor)
        ].activate()
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        [
            userName.centerYAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 45),
            userName.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            userName.leadingAnchor.constraint(greaterThanOrEqualTo: wrapper.leadingAnchor, constant: 25),
            userName.trailingAnchor.constraint(greaterThanOrEqualTo: wrapper.trailingAnchor, constant: 25)
        ].activate()
        
        locationAndAboutWrapper.translatesAutoresizingMaskIntoConstraints = false
        [
            locationAndAboutWrapper.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            locationAndAboutWrapper.leadingAnchor.constraint(greaterThanOrEqualTo: wrapper.leadingAnchor, constant: 25),
            locationAndAboutWrapper.trailingAnchor.constraint(greaterThanOrEqualTo: wrapper.trailingAnchor, constant: 25),
            locationAndAboutWrapper.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 27),
            locationAndAboutWrapper.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -40)
        ].activate()
        
        location.translatesAutoresizingMaskIntoConstraints = false
        [
            location.leadingAnchor.constraint(equalTo: locationAndAboutWrapper.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: locationAndAboutWrapper.trailingAnchor),
            location.topAnchor.constraint(equalTo: locationAndAboutWrapper.topAnchor, constant: 5)
        ].activate()
        
        about.translatesAutoresizingMaskIntoConstraints = false
        [
            about.topAnchor.constraint(equalTo: location.bottomAnchor),
            about.leadingAnchor.constraint(equalTo: locationAndAboutWrapper.leadingAnchor),
            about.trailingAnchor.constraint(equalTo: locationAndAboutWrapper.trailingAnchor),
            about.bottomAnchor.constraint(equalTo: locationAndAboutWrapper.bottomAnchor)
        ].activate()
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        [
            buttonsStackView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonsStackView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -30)
        ].activate()
    }
}
