//
//  ConversationsListViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit
import iChatLib
import CoreData

class ConversationsListViewController: UIViewController, IStoryboardViewController, UINavigationControllerDelegate {
    @IBOutlet private var tableView: UITableView!
    
    private var container: IServiceResolver!
    private var themeProvider: IThemeProvider!
    private var ctxProvider: IViewContextProvider!
    private var channelsManager: IChannelsManager!
    
    func setupDependencies(with container: IServiceResolver) {
        self.container = container
        self.themeProvider = container.resolve(for: IThemeProvider.self)
        self.ctxProvider = container.resolve(for: IViewContextProvider.self)
        self.channelsManager = container.resolve(for: IChannelsManager.self)
    }
    
    lazy var avatarView: AvatarView = {
        let aView = AvatarView.fromNib()
        let profileProvider: IProfileInfoProvider = container.resolve()
        aView.configure(with: profileProvider.profile)
        aView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        aView.delegate = self
        return aView
    }()
    
    lazy var newChannelAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "New channel",
                                                message: "Please, enter name of the channel:",
                                                preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.textFields?.first?.text = nil
        }
        
        alertController.addAction(cancel)
        alertController.addAction(addChannelAction)
        
        alertController.addTextField { [weak self] tf in
            tf.addTarget(self, action: #selector(self?.newChannelTextFieldValueChanged(sender:)), for: .editingChanged)
        }
        
        return alertController
    }()
    
    lazy var addChannelAction: UIAlertAction = {
        let add = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let sSelf = self,
                let name = sSelf.newChannelAlertController.textFields?.first?.text?.trimmed
                else { return }
            
            sSelf.newChannelAlertController.textFields?.first?.text = nil
            sSelf.channelsManager.create(with: name)
        }
        add.isEnabled = false
        return add
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSManagedChannel> = {
        let fetchRequest = NSManagedChannel.fetchRequest
        let timeDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [timeDescriptor]
        let frc: NSFetchedResultsController =
            NSFetchedResultsController<NSManagedChannel>(fetchRequest: fetchRequest,
                                                         managedObjectContext: ctxProvider.viewContext,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
        return frc
    }()
    
    private let rowHeight = CGFloat(89)
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
    
    private func configureNavigation() {
        navigationItem.title = "Channels"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.setupAppearance(with: themeProvider)
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConversationCell.nib, forCellReuseIdentifier: cellIdentifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.insetsContentViewsToSafeArea = true
    }
    
    @objc func setupFetchResultsController() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("Unable to perform fetch.")
        }
        fetchedResultsController.delegate = self
        tableView.reloadData()
    }
    
    private func setupRightBarButtonItem() {
        let avatarButton = UIBarButtonItem(customView: avatarView)
        let newChannelButton = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(presentNewChannelAlert(_:)))
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
    
    private func presentConversation(for channel: IChannel) {
        navigationItem.title = nil
        let conversationVC: ConversationViewController = container.resolve()
        conversationVC.configure(with: channel)
        self.show(conversationVC.forPresentation, sender: nil)
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
        // instantiate vc
        let userPageVC: UserPageViewController = container.resolve()
        
        // setup callbacks
        userPageVC.profileHasBeenChanged = { [weak self] p in
            DQ.main.async { self?.avatarView.image = p.image }
        }
        
        // present
        self.present(userPageVC.forPresentation, animated: true)
    }
}

// MARK: - UIViewController
extension ConversationsListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureTableView()
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
        setupFetchResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController.delegate = nil
    }
    
}

// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ConversationCell
            else { fatalError("Cast to ConversationCell failed.") }
        let channel = fetchedResultsController.object(at: indexPath)
        cell.configure(with: channel)
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
        
        guard let channel = cell.model
            else { assertionFailure("Unable to unwrap ConversationInfo."); return }
        
        presentConversation(for: channel)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // should be able to edit
        let channel = fetchedResultsController.object(at: indexPath)
        if channel.ownerId != UIDevice.vendorUid { return [] }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, _) in
            self?.channelsManager.remove(channel)
        }
        
        //        let edit = UITableViewRowAction(style: .default, title: "Rename") { (action, indexPath) in
        //
        //        }
        //        edit.backgroundColor = UIColor.lightGray
        
        return [delete]
        
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange anObject: Any,
                   at indexPath: IndexPath?,
                   for type: NSFetchedResultsChangeType,
                   newIndexPath: IndexPath?) {
       
       // something like bounds check for controller
       // https://stackoverflow.com/a/25051056/9667748
       // https://gist.github.com/The0racle/3b6c0e9d8c73c4b1727605117af5e213
       if let indexPath = indexPath, !controller.hasObject(at: indexPath) {
           return
       }
       
       switch type {
       case .insert:
           if let indexPath = newIndexPath {
               tableView.insertRows(at: [indexPath], with: .automatic)
           }
       case .update:
           if let indexPath = indexPath {
               guard let channel = controller.object(at: indexPath) as? IChannel,
                   let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { return }
               cell.configure(with: channel)
           }
       case .move:
           if let indexPath = indexPath {
               tableView.deleteRows(at: [indexPath], with: .automatic)
           }
           if let newIndexPath = newIndexPath {
               tableView.insertRows(at: [newIndexPath], with: .automatic)
           }
       case .delete:
           if let indexPath = indexPath {
               tableView.deleteRows(at: [indexPath], with: .automatic)
           }
       @unknown default: return
       }
   }
}
