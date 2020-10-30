//
//  PersistenceManager.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

protocol IPersistenceManager {
    func persist(data: Data, to path: URL, _ completion: @escaping (Error?) -> Void)
    func persist<T: NSCoding>(_ item: T, to path: URL, _ completion: @escaping (Error?) -> Void)
    func read<T>(from path: URL, _ completion: @escaping (Error?, T?) -> Void)
}
