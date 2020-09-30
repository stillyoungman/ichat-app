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
    
    private let rowHeight = CGFloat(89);
    private let headerHeight = CGFloat(89 / 2.5)
    private let tableCellLeadingInset = CGFloat(16)
    private let numberOfSections = 2
    private let cellIdentifier = ConversationCell.typeName
    private let headerIdentifier = HeaderView.typeName
    private let dataProvider = ConversationsProvider.instance
    
    private var headerLeadingInset: CGFloat {
        var leadingInset: CGFloat = tableCellLeadingInset
        if #available(iOS 11.0, *) {
            //possible issue for `right to left` systems
            leadingInset += UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0
        }
        return leadingInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
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
    }
    
    private func configureNavigation(){
        navigationItem.title = "Tinkoff Chat"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupRightBarButtonItem(){
        let aView = AvatarView.fromNib()
        aView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        aView.delegate = self
        aView.userName = "Constantine Nikolsky"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: aView)
    }
    
    private func setupLeftBarButtonItem() {
        let frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let iconButton = UIButton(frame: frame)
        iconButton.setBackgroundImage(#imageLiteral(resourceName: "settings.png"), for: .normal)
        let settings = UIBarButtonItem(customView: iconButton)
        settings.tintColor = UIColor.init(hex: "#545458") ?? UIColor.systemGray.withAlphaComponent(0.65)
        settings.customView?.translatesAutoresizingMaskIntoConstraints = false
        settings.customView?.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
        settings.customView?.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        navigationItem.leftBarButtonItem = settings
    }
}


extension ConversationsListViewController: ExtendedNavBarDelegate {
    func heightWasChanged(_ height: CGFloat) {
        print(height)
    }
}

extension ConversationsListViewController: AvatarViewDelegate {
    func viewDidTapped() {
        let presentedView = UINavigationController(rootViewController: UserPageViewController.fromStoryboard())
        self.present(presentedView, animated: true)
    }
}

extension ConversationsListViewController {
    
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

extension ConversationsListViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataProvider.conversations(for: ConversationType.parse(section)).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ConversationCell
            else { fatalError("Cast to ConversationCell failed.") }
        cell.configure(with:
            dataProvider.conversations(for: ConversationType.parse(indexPath.section))[indexPath.row])
        return cell
    }
    
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { rowHeight }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
            as? HeaderView else {
                fatalError("Cast to HeaderView failed.")
        }
        header.configure(with: ConversationType.parse(section).toString())
        header.leadingInset = headerLeadingInset
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        headerHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.title = nil
        guard let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { return }
        cell.setSelected(false, animated: true)
        
        let destination = ConversationViewController.fromStoryboard()
        destination.navigationItem.title = cell.model?.name
        self.show(destination, sender: nil)
    }
}
