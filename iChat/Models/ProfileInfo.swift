//
//  ProfileInfo.swift
//  iChat
//
//  Created by Constantine Nikolsky on 08.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation
import UIKit

class ProfileInfo: NSObject, NSCoding, IProfileInfo {
    var username: String
    var about: String
    var location: String
    var image: UIImage?
    
    required init?(coder: NSCoder) {
        guard let username = coder.decodeObject(forKey: CodingKeys.username.rawValue) as? String,
            let about = coder.decodeObject(forKey: CodingKeys.description.rawValue) as? String,
            let location = coder.decodeObject(forKey: CodingKeys.location.rawValue) as? String
            else { return nil }
        self.username = username
        self.about = about
        self.location = location
        image = coder.decodeObject(forKey: CodingKeys.image.rawValue) as? UIImage
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(username, forKey: CodingKeys.username.rawValue)
        coder.encode(about, forKey: CodingKeys.description.rawValue)
        coder.encode(location, forKey: CodingKeys.location.rawValue)
        coder.encode(image, forKey: CodingKeys.image.rawValue)
    }
    
    init(username: String,
         about: String,
         location: String,
         image: UIImage? = nil) {
        self.username = username
        self.about = about
        self.location = location
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case username,
        description = "userDescription",
        location, image
    }
}
