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
    
    func handle(completion: @escaping (Error?) -> ()){
        
    }
    
    func save(_ manager: IPersistenceManager? = nil, profile: ProfileInfo, completion: @escaping (Error?) -> ()) {
        let wraper: (Error?) -> () = { [weak self] err in
            if err == nil {
                self?._profile = profile
            }
            completion(err)
        }
        (manager ?? persistenceManager).persist(profile, to: profileURL, wraper)
    }
    
    func get(_ manager: IPersistenceManager? = nil, completion: @escaping (Error?, IProfileInfo?) -> ()) {
        (manager ?? persistenceManager).read(from: profileURL, completion)
    }
    
    let dispatchGroup  = DispatchGroup()
    private init() {
        self.dispatchGroup.enter()
        get { err, prof in
            if err != nil {
                fatalError("Unable to read user profile")
            }
            if prof == nil {
                //initial save
                self.save(profile: self.`default`) { e in
                    if e != nil { fatalError("Unable to persist default user profile") }
                }
                self._profile = self.`default`
            } else {
                self._profile = prof
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.wait()
    }
}
