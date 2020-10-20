//
//  GProfileInfoProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class GPersistenceManager: IPersistenceManager {
    let base = BasePersistenceManager()
    func read<T>(from path: URL, _ completion: @escaping (Error?, T?) -> Void) {
        DQ.global(qos: .utility).async {
            self.base.read(from: path, completion)
        }
        
    }
    
    func persist(data: Data, to path: URL, _ completion: @escaping (Error?) -> Void) {
        DQ.global(qos: .utility).async {
            self.base.persist(data: data, to: path, completion)
        }
    }
    
    func persist<T: NSCoding>(_ item: T, to path: URL, _ completion: @escaping (Error?) -> Void) {
        DQ.global(qos: .utility).async {
            self.base.persist(item, to: path, completion)
        }
    }
}
