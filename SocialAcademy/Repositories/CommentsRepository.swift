//
//  CommentsRepository.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/6/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: - CommentRepository Protocol

protocol CommentsRepositoryProtocol {
    var user: User { get }
    var post: Post { get }
    func fetchComments() async throws -> [Comment]
    func create(_ comment: Comment) async throws
    func delete(_ comment: Comment) async throws
}

//MARK: - CommentsRepository

struct CommentsRepository: CommentsRepositoryProtocol {
    var user: User
    
    var post: Post
    
    private var commentsReference: CollectionReference {
        let postReference = Firestore.firestore().collection("posts_v2")
        let document = postReference.document(post.id.uuidString)
        return document.collection("comments")
    }
    
    func fetchComments() async throws -> [Comment] {
        return try await commentsReference
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Comment.self)
    }
    
    func create(_ comment: Comment) async throws {
        let document = commentsReference.document(comment.id.uuidString)
        try await document.setData(from: comment)
    }
    
    func delete(_ comment: Comment) async throws {
        precondition(canDelete(comment))
        let document = commentsReference.document(comment.id.uuidString)
        try await document.delete()
    }
    
    
}

//MARK: - extension to CommentRepository protocol to determinate if a user can delete a comment

extension CommentsRepositoryProtocol {
    func canDelete(_ comment: Comment) -> Bool {
        comment.author.id == user.id ? true : false
    }
}

//MARK: - CommentRepositoryStub

#if DEBUG
struct CommentsRepositoryStub: CommentsRepositoryProtocol {
    
    let user = User.testUser
    
    let post = Post.testPost
    
    let state: Loadable<[Comment]>
    
    func fetchComments() async throws -> [Comment] {
        return try await state.simulate()
    }
    
    func create(_ comment: Comment) async throws {
        
    }
    
    func delete(_ comment: Comment) async throws {
        
    }
}
#endif
