//
//  ConversationViewViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 30.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: UIViewController, IStoryboardViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let messages = [
        MessageModel("hi", true),
        MessageModel("Прив)", false),
        MessageModel("At vero eos et accusamus et iusto odio dignissimos", false),
        MessageModel("Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis", false),
//        MessageModel("debitis aut rerum necessitatib", true),
        MessageModel("rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus", true),
        MessageModel("voluptate velit esse cillum dolore eu fugiat nulla pariatur", false),
        MessageModel("Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatu", true),
        MessageModel("consectetur adipiscing elit", false),
        MessageModel(" laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat ", true)
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigation()
    }
    
    private func configureNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTableView(){
        tableView.register(MessageTableViewCell.nib, forCellReuseIdentifier: MessageTableViewCell.typeName)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 600
        
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    private func configure(){
        
    }
}

extension ConversationViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 50 }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.typeName) as? MessageTableViewCell
            else { fatalError("Unable cast the cell to \(MessageCell.typeName)") }


        cell.configure( messages[indexPath.row])
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))

        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.typeName) as? MessageCell
//            else { fatalError("Unable cast the cell to \(MessageCell.typeName)") }
//        
//        
//        cell.configure(with: messages[indexPath.row])
////        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//    
//    }
    
    
}

class MessageModel {
    var text: String?
    var time: Date?
    var senderGuid: String?
    var isOutput: Bool = false
    
    init(_ text: String, _ isMine: Bool) {
        self.text = text
        self.isOutput = isMine
    }
}
