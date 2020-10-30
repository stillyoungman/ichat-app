//
//  ConversationViewController+SetupConstraints.swift
//  iChat
//
//  Created by Constantine Nikolsky on 22.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

extension ConversationViewController {
    func setupConstraints() {
        currentLayoutConstraints = defaultLayoutConstraints
        currentLayoutConstraints.activate()
        
        view.addSubview(tableView)
        view.addSubview(messageInputContainerView)
        
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        [
            messageInputContainerView.widthAnchor.constraint(equalTo: wrapper.widthAnchor),
            messageInputContainerView.heightAnchor.constraint(equalToConstant: 60),
            messageInputContainerView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            messageInputContainerView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ].activate()
        
        messageInputContainerView.addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        [
            inputTextField.widthAnchor.constraint(equalTo: messageInputContainerView.widthAnchor, multiplier: 0.8),
            inputTextField.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor),
            inputTextField.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor),
            inputTextField.heightAnchor.constraint(equalTo: messageInputContainerView.heightAnchor)
        ].activate()
        
        messageInputContainerView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        [
            sendButton.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant: -30),
            sendButton.heightAnchor.constraint(equalTo: messageInputContainerView.heightAnchor, multiplier: 0.5),
            sendButton.aspectRatio(1)
        ].activate()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        [
            tableView.widthAnchor.constraint(equalTo: wrapper.widthAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: -15)
        ].activate()
    }
}
