//
//  InfoData.swift
//  uikit_app
//
//  Created by Mercedes Franchesca Gonzalez Cejas on 22/8/23.
//

import UIKit

class Character: Hashable {
    let id: Int64
    let name: String
    let role: String
    let image_url: String
    var imageData: Data?
    var nicknames: [String]?
    var about: String?
    
    init(id: Int64, name: String, role: String, image_url: String, imageData: Data? = nil, nicknames: [String]? = nil, about: String? = nil) {
        self.id = id
        self.name = name
        self.role = role
        self.image_url = image_url
        self.imageData = imageData
        self.nicknames = nicknames
        self.about = about
    }
    
    func toString() -> String {
        return "name: \(name), role: \(role), image_url: \(image_url)"
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
