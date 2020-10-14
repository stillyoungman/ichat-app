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
        username = coder.decodeObject(forKey: CodingKeys.username.rawValue) as! String
        about = coder.decodeObject(forKey: CodingKeys.description.rawValue) as! String
        location = coder.decodeObject(forKey: CodingKeys.location.rawValue) as! String
        image = coder.decodeObject(forKey: CodingKeys.image.rawValue) as? UIImage
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        username = try container.decode(String.self, forKey: .username)
//        userDescription = try container.decode(String.self, forKey: .description)
//        location = try container.decode(String.self, forKey: .location)
//        if let imageData = try? container.decode(Data?.self, forKey: .image) {
//            image = UIImage(data: imageData)
//        }
//    }
    
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


//extension ProfileInfo: Codable {
//    
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(description, forKey: .description)
//        try container.encode(username, forKey: .username)
//        try container.encode(location, forKey: .location)
//        try container.encode(image?.pngData() ?? image?.jpegData(compressionQuality: 1), forKey: .image)
//    }
//
//    
//}
