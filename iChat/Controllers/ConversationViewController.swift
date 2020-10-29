//
//  ConversationViewViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: GuidedViewController, IStoryboardViewController, IConfigurable {
    lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    lazy var messageInputContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "send")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func sendMessage(_ sender: UIButton) {
        guard let text = inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if text.isEmpty { inputTextField.text = nil; return }
        
        model.conversation.send(text, from: profileProvider.profile.username)
        inputTextField.text = nil
    }
    
    lazy var inputTextField: UITextField = {
        let i = TextField()
        i.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        i.clearButtonMode = .always
        i.placeholder = "Enter your message..."
        return i
    }()
    
    var model: IConversationViewModel!
    var themeManager: IThemeProvider!
    var profileProvider: IProfileInfoProvider!
    var storage: IPersistentStorage!
    
    func setupDependencies(with container: IServiceResolver) {
        themeManager = container.resolve(for: IThemeProvider.self)
        profileProvider = container.resolve(for: IProfileInfoProvider.self)
        storage = container.resolve(for: IPersistentStorage.self)
    }
    
    func configure(with model: IConversationViewModel) {
        self.model = model
        self.title = model.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigation()
        setupAppearance()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendButton.setTitleColor(themeManager.value.navTintColor, for: .normal)
        model.conversation.subscribe { [weak self] in
            guard let sSelf = self else { return }
            
            DQ.global(qos: .utility).async {
                let channelUid = sSelf.model.conversation.channelUid
                let messages = sSelf.model.conversation.messages
                sSelf.storage.persist(messages, of: channelUid)
            }
            
            sSelf.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.conversation.unsubscribe()
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func configureTableView() {
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.typeName)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    private func setupAppearance() {
        view.backgroundColor = themeManager.value.background
        tableView.backgroundColor = themeManager.value.background
    }
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.typeName) as? MessageCell
            else { fatalError("Unable cast the cell to \(MessageCell.typeName)") }
        
        cell.apply(themeManager.value, for: themeManager.mode)
        cell.configure(with: model.conversation.messages[indexPath.row])
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))

        return cell
    }
}
