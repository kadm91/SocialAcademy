//
//  Post.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/22/24.
//

import Foundation

struct Post: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var content: String
    var author: User
    var timestamp = Date()
    var isFavorite = false 
    
    
    func contains(_ string: String) -> Bool {
        let properties = [title, content, author.name ].map {$0.lowercased()}
        let query = string.lowercased()
        let matches = properties.filter {$0.contains(query)}
        return !matches.isEmpty
    }
    
    init(title: String, content: String, author: User, timestamp: Date = Date()) {
     
        self.title = title
        self.content = content
        self.author = author
        self.timestamp = timestamp
    }
    
    init() {
        self.init( title: "",
                   content: "",
                   author: User(id: "", name: ""))
    }
    
    
}

extension Post: Codable {
    enum CodingKeys: CodingKey {
        case title, content, author, timestamp, id
    }
}

extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        author: User.testUser
    )
}
