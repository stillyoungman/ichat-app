//
//  TViewController.swift
//  iChat
//
//  Created by Constantine Nikolsky on 12.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import UIKit

class PTViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        Self.trace()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        trace()
    }
    
    required init?(coder: NSCoder) {
        Self.trace()
        super.init(coder: coder)
        trace()
    }
    
    override func setNeedsFocusUpdate() {
        trace(.in)
        super.setNeedsFocusUpdate()
        trace()
    }
    
    override func awakeFromNib() {
        trace(.in)
        super.awakeFromNib()
        trace()
    }
    
    override func loadViewIfNeeded() {
        trace(.in)
        super.loadViewIfNeeded()
        trace()
    }
    
    override func viewDidLoad() {
        trace(.in)
        super.viewDidLoad()
        trace()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trace(.in)
        super.viewWillAppear(animated)
        trace()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        trace(.in)
        super.viewDidAppear(animated)
        trace()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        trace(.in)
        super.viewWillDisappear(animated)
        trace()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        trace(.in)
        super.viewDidDisappear(animated)
        trace()
    }
    
    override func viewWillLayoutSubviews() {
        trace(.in)
        super.viewWillLayoutSubviews()
        trace()
    }
    
    override func viewDidLayoutSubviews() {
        trace(.in)
        super.viewDidLayoutSubviews()
        trace()
    }
    
    override func loadView() {
        trace(.in)
        super.loadView()
        trace()
    }
    
    override func addChild(_ childController: UIViewController) {
        trace(.in)
        super.addChild(childController)
        trace()
    }
    
    override func removeFromParent() {
        trace(.in)
        super.removeFromParent()
        trace()
    }
    
    override func applicationFinishedRestoringState() {
        trace(.in)
        super.applicationFinishedRestoringState()
        trace()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        trace(.in)
        super.setEditing(editing, animated: animated)
        trace()
    }
}
