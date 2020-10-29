//
//  ConversationsListViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ConversationsListViewController: UIViewController, IStoryboardViewController, UINavigationControllerDelegate {
    @IBOutlet private var tableView: UITableView!
    
    lazy var avatarView: AvatarView = {
        let aView = AvatarView.fromNib()
        let profileProvider: IProfileInfoProvider = container.resolve()
        aView.configure(with: profileProvider.profile)
        aView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        aView.delegate = self
        return aView
    }()
    
    lazy var newChannelAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "New channel", message: "Please, enter name of the channel:", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.textFields?.first?.text = nil
        }
        
        alertController.addAction(cancel)
        alertController.addAction(self.addChannelAction)
        
        alertController.addTextField { tf in
            tf.addTarget(self, action: #selector(self.newChannelTextFieldValueChanged), for: .editingChanged)
        }
        
        return alertController
    }()
    
    lazy var addChannelAction: UIAlertAction = {
        let add = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let sSelf = self,
                let name = sSelf.newChannelAlertController.textFields?.first?.text?.trimmed
                    else { return }
            
            sSelf.newChannelAlertController.textFields?.first?.text = nil
            sSelf.channelsProvider.create(Channel(identifier: "", name: name, lastMessage: nil, lastActivity: nil, ownerId: UIDevice.vendorUid ))
        }
        add.isEnabled = false
        return add
    }()
    
    private let rowHeight = CGFloat(89)
    private let headerHeight = CGFloat(89 / 2.5)
    private let tableCellLeadingInset = CGFloat(16)
    private let cellIdentifier = ConversationCell.typeName
    private let headerIdentifier = HeaderView.typeName
    
    private var headerLeadingInset: CGFloat {
        var leadingInset: CGFloat = tableCellLeadingInset
        if #available(iOS 11.0, *) {
            //possible issue for `right to left` systems
            leadingInset += UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0
        }
        return leadingInset
    }
    
    private var container: IServiceResolver!
    private var themeProvider: IThemeProvider!
    private var channelsProvider: IChannelsProvider!
    private var storage: IPersistentStorage!
    
    func setupDependencies(with container: IServiceResolver) {
        self.container = container
        self.channelsProvider = container.resolve(for: IChannelsProvider.self)
        self.themeProvider = container.resolve(for: IThemeProvider.self)
        self.storage = container.resolve(for: IPersistentStorage.self)
    }
    
    private func configureNavigation() {
        navigationItem.title = "Channels"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.setupAppearance(with: themeProvider)
    }
    
    private func setupRightBarButtonItem() {
        let avatarButton = UIBarButtonItem(customView: avatarView)
        let newChannelButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentNewChannelAlert(_:)))
        navigationItem.rightBarButtonItems = [avatarButton, newChannelButton]
    }
    
    private func setupLeftBarButtonItem() {
        let frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let iconButton = UIButton(type: .system)
        
        iconButton.addTarget(self, action: #selector(presentThemeSettings(_:)), for: .touchUpInside)
        let image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        iconButton.setBackgroundImage(image, for: .normal)
        let settings = UIBarButtonItem(customView: iconButton)
        settings.customView?.translatesAutoresizingMaskIntoConstraints = false
        settings.customView?.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
        settings.customView?.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        navigationItem.leftBarButtonItem = settings
    }
    
    private func presentConversation(for channelInfo: Channel) {
        navigationItem.title = nil
        let destination = ConversationViewController.instantiate(container: container)
        let conversationsProvider: IConversationsProvider = container.resolve()
        let conversation = conversationsProvider.conversation(for: channelInfo.identifier)
        let viewModel = ConversationViewModel(title: channelInfo.name, conversation: conversation)
        destination.configure(with: viewModel)
        self.show(destination, sender: nil)
    }
    
    @objc func presentThemeSettings(_ btn: AnyObject) {
        navigationItem.title = nil
        let destination = ThemesViewController.instantiate(container: container)
        destination.themeChanged = { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.setupAppearance()
            sSelf.tableView.reloadData()
        }
        destination.delegate = self
        self.show(destination, sender: nil)
    }
    
    @objc func presentNewChannelAlert(_ btn: AnyObject) {
        present(newChannelAlertController, animated: true)
    }
    @objc func newChannelTextFieldValueChanged(sender: UITextField) {
        addChannelAction.isEnabled = !sender.text.isNilOrEmpty
    }
    
    func setupAppearance() {
        view.backgroundColor = themeProvider.value.background
        navigationController?.setupAppearance(with: themeProvider)
    }
}

extension ConversationsListViewController: ThemesPickerDelegate {
    func themeChanged(_ mode: ThemeMode) {
        print("theme changed: \(mode)")
    }
}

extension ConversationsListViewController: AvatarViewDelegate {
    func viewDidTapped() {
        presentUserPageController()
    }
    
    private func presentUserPageController() {
        let userPageVC: UserPageViewController = container.resolve()
        
        userPageVC.profileHasBeenChanged = { [weak self] p in
            DQ.main.async { self?.avatarView.image = p.image }
        }
        
        self.present(userPageVC.forPresentation, animated: true)
    }
}

// MARK: - UIViewController
extension ConversationsListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConversationCell.nib, forCellReuseIdentifier: cellIdentifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.insetsContentViewsToSafeArea = true
        
        configureNavigation()
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
        
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
        channelsProvider.subscribe { [weak self] in
            guard let sSelf = self else { return }
            DQ.global(qos: .utility).async {
                sSelf.storage.persist(sSelf.channelsProvider.items)
            }
            DQ.main.async {
                sSelf.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        channelsProvider.unsubsribe()
    }
    
    ///Updates leading inset of tableViewHeader when screen orientation was changed
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            for section in 0 ..< self.tableView.numberOfSections {
                guard let header = self.tableView.headerView(forSection: section) as? HeaderView
                    else { continue }
                header.leadingInset = self.headerLeadingInset
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channelsProvider.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ConversationCell
            else { fatalError("Cast to ConversationCell failed.") }
        cell.configure(with: channelsProvider.items[indexPath.row])
        cell.apply(themeProvider.value, for: themeProvider.mode)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { rowHeight }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { return }
        cell.setSelected(false, animated: true)
        
        guard let channelInfo = cell.model
            else { assert(false, "Unable to unwrap ConversationInfo."); return }
        
        presentConversation(for: channelInfo)
    }
}
