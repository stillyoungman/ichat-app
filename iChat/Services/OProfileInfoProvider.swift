//
//  OProfileInfoProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class SaveOperation: Operation {
    
    let data: Data
    let path: URL
    let completion: (Error?) -> ()
    
    init(_ data: Data, to path: URL, completion: @escaping (Error?) -> ()) {
        self.data = data
        self.path = path
        self.completion = completion
    }
    
    override func main() {
        let base = BasePersistenceManager()
        base.persist(data: data, to: path, completion)
    }
}

class ReadOperation<T>: Operation {
    let path: URL
    let completion: Handler
    
    typealias Handler = (Error?, T?) -> Void
    
    init(_ data: Data, to path: URL, _ completion: @escaping Handler) {
        self.path = path
        self.completion = completion
    }
    
    override func main() {
        let base = BasePersistenceManager()
        base.read(from: path, completion)
    }
}

class OPersistenceManager: IPersistenceManager {
    private let queue: OperationQueue
    
    init() {
        queue = OperationQueue()
        queue.qualityOfService = .utility
    }
    
    func persist(data: Data, to path: URL, _ completion: @escaping (Error?) -> ()) {
        queue.addOperation(SaveOperation(data, to: path, completion: completion))
    }
    
    func persist<T: NSCoding>(_ item: T, to path: URL, _ completion: @escaping (Error?) -> ()) {
        queue.addOperation {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
                self.queue.addOperation(SaveOperation(data, to: path, completion: completion))
            }
            catch {
                print(error.localizedDescription)
                completion(AppError())
            }
        }
    }
    
    func read<T>(from path: URL, _ completion: @escaping (Error?, T?) -> ()) {
        
    }
}
