//
//  User.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/4/24.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
    var imageURL: URL?
    
    
}


//MARK: - Test User

extension User {
    static let testUser = User(id: "", name: "Jamie Harris", imageURL: URL(string: "https://source.unsplash.com/lw9LrnpUmWw/480x480"))
}


