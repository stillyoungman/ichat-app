//
//  GProfileInfoProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 15.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class BasePersistanceManager: IPersistanceManager {
    
}

class GPersistanceManager: IPersistanceManager {
    func read<T>(from path: URL, _ completion: @escaping (Error?, T?) -> ()) {
        DQ.global(qos: .utility).async {
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
        
    }
    
    func persist(data: Data, to path: URL, _ completion: @escaping (Error?) -> ()) {
        DQ.global(qos: .utility).async {
            do {
                try data.write(to: path)
                completion(nil)
            }
            catch {
                completion(AppError())
            }
        }
    }
    
    func persist(_ item: NSCoding, to path: URL, _ completion: @escaping (Error?) -> ()) {
        DQ.global(qos: .utility).async {
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
}
