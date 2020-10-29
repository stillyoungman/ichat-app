//
//  IPersistentStorage.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import CoreData

protocol IPersistentStorage {
    func performSave(_ populate: (NSManagedObjectContext) -> Void)
}

extension IPersistentStorage {
    func persist(_ channels: [Channel]) {
        self.performSave {
            for channel in channels {
                debug { sleep(1) }
                _ = NSManagedChannel(channel, of: $0)
            }
        }
    }
    
    func persist(_ messages: [Message], of channelUid: String) {
        self.performSave {
            let fetchRequest: NSFetchRequest<NSManagedChannel> = NSManagedChannel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(NSManagedChannel.identifier), channelUid)
            do {
                guard let channel = (try $0.fetch(fetchRequest)).first else { return }
                for message in messages {
                    debug { sleep(1) }
                    let message = NSManagedMessage(message, of: $0)
                    message.channel = channel
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
