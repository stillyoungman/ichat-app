//
//  BasePersistenceManager.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class BasePersistenceManager: IPersistenceManager {
    func read<T>(from path: URL, _ completion: @escaping (Error?, T?) -> ()) {
        do {
            guard let data = try? Data(contentsOf: path) else {
                completion(nil, nil)
                return
            }
            
            let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
            completion(nil, result)
        } catch {
            completion(AppError(), nil)
        }
    }
    
    func persist(data: Data, to path: URL, _ completion: @escaping (Error?) -> ()) {
        do {
            try data.write(to: path)
            completion(nil)
        }
        catch {
            completion(AppError())
        }
    }
    
    func persist<T: NSCoding>(_ item: T, to path: URL, _ completion: @escaping (Error?) -> ()) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
            self.persist(data: data, to: path, completion)
        }
        catch {
            print(error.localizedDescription)
            completion(AppError())
        }
    }
}
