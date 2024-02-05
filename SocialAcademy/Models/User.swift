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
    
    
}


//MARK: - Test User

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}


