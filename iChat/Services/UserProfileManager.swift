//
//  UserProfileManager.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class UserProfileManager: IProfileInfoProvider {
    var profile: IProfileInfo { _profile }
    
    static let shared = UserProfileManager()
    private let persistenceManager: IPersistenceManager = GPersistenceManager()
    
    var _profile: IProfileInfo!
    let profileURL = FileManager.default.documents.appendingPathComponent("profile.bin")
    
    let `default` = ProfileInfo(username: "Constantine Nikolsky",
                                            about: "Junior iOS developer",
                                            location: "Moscow, Russia",
                                            image: UIImage(named: "droid"))
    
    func handle(completion: @escaping (Error?) -> Void) {
        
    }
    
    func save(_ manager: IPersistenceManager? = nil, profile: ProfileInfo, completion: @escaping (Error?) -> Void) {
        let wraper: (Error?) -> Void = { [weak self] err in
            if err == nil {
                self?._profile = profile
            }
            completion(err)
        }
        (manager ?? persistenceManager).persist(profile, to: profileURL, wraper)
    }
    
    func get(_ manager: IPersistenceManager? = nil, completion: @escaping (Error?, IProfileInfo?) -> Void) {
        (manager ?? persistenceManager).read(from: profileURL, completion)
    }
    
    let dispatchGroup = DispatchGroup()
    private init() {
        self.dispatchGroup.enter()
        get { [weak self] err, prof in
            guard let sSelf = self else { return }
            if err != nil {
                fatalError("Unable to read user profile")
            }
            if prof == nil {
                //initial save
                sSelf.save(profile: sSelf.`default`) { e in
                    if e != nil { fatalError("Unable to persist default user profile") }
                }
                sSelf._profile = sSelf.`default`
            } else {
                sSelf._profile = prof
            }
            sSelf.dispatchGroup.leave()
        }
        dispatchGroup.wait()
    }
}
