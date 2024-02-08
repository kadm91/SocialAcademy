//
//  PostRowViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/31/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject, ErrorHandler {
    typealias Action = () async throws -> Void
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action?
    private let favoriteAction: Action
    
    var canDeletePost: Bool { deleteAction != nil }
    
    init(post: Post, deleteAction: Action?, favoriteAction: @escaping Action) {
        self.post = post
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
    
    //MARK: - DynamicMember
    
    subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
        post[keyPath: keyPath]
    }
    
    //MARK: - intenttions
    
    
     func deletePost() {
         guard let deleteAction = deleteAction else {
             preconditionFailure("Cannot Delete post: no delte action provided")
         }
       withErrorHandlingTask(perform: deleteAction)
    }
    
    
     func favoritePost() {
         withErrorHandlingTask(perform: favoriteAction)
    }
}
