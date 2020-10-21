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
    var themeManager: IThemeProvider!
    
    func setupDependencies(with container: IServiceResolver) {
        themeManager = container.resolve(for: IThemeProvider.self)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.conversation.subscribe { [weak self] in
            guard let sSelf = self else { return }
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
