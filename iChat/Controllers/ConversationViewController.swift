//
//  ConversationViewViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: UIViewController, IStoryboardViewController, IConfigurable {
    @IBOutlet weak var tableView: UITableView!
    var model: IConversationViewModel!
    var themeManager: AnyObject!
    
    func setupDependencies(with container: IServiceResolver) {
        themeManager = nil
    }
    
    func configure(with model: IConversationViewModel) {
        self.model = model
        self.title = model.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigation()
        setupTheme()
    }
    
    private func configureNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func configureTableView(){
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.typeName)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    private func setupTheme() {
        // TODO: Add implementation
    }
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.conversation.messages.values.reduce(0, { $0 + $1.count })}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.conversation.messages.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.typeName) as? MessageCell
            else { fatalError("Unable cast the cell to \(MessageCell.typeName)") }
        
        cell.configure(with: model.conversation.getMessage(for: indexPath))
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))

        return cell
    }
}


