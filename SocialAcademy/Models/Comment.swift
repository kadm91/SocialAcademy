//
//  Comment.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/6/24.
//

import Foundation

struct Comment: Identifiable, Equatable, Codable {
    var content: String
    var author: User
    var timestamp = Date()
    var id = UUID()
}

//MARK: - testComment

extension Comment {
    static let testComment = Comment(content: "Lorem ipsum dolor set amet.", author: User.testUser)
}
