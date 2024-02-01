//
//  PostsRepository.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/24/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: - PostRepository Protocol

protocol PostsRepositoryProtocol {
    func fetchAllPosts () async throws -> [Post]
    func fetchFavoritePosts() async throws  -> [Post]
    func create (_ post: Post) async throws
    func delete (_ post: Post) async throws
    func favorite (_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
}


struct PostsRepository: PostsRepositoryProtocol {
    
    var postsReference = Firestore.firestore().collection("posts_v1")
    
    //createe
    
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    //Fetch
    
    func fetchAllPosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference)
        
    }
    
    // Fetch Favorite Posts
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("isFavorite", isEqualTo: true))
    }
    
    // Delete
    
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    // Favorite
    
    func favorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": true], merge: true)
    }
    
    
    // Unfavorite
    func unfavorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": false], merge: true)
    }
    
    
    //MARK: - Helper Methods
    
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let query = query.order(by: "timestamp", descending: true)
        let snapshot = try await query.getDocuments()
        let posts = snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
        return posts
    }
    
}


//MARK: - DocumentReference extension

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}


//MARK: - Posts Repository Stub

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    func fetchFavoritePosts() async throws -> [Post] {
        return [Post]()
    }
    
    func favorite(_ post: Post) async throws {
        
    }
    
    func unfavorite(_ post: Post) async throws {
        
    }
    
    
    func delete(_ post: Post) async throws {
        
    }
    
    
    
    let state: Loadable<[Post]>
    
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func create(_ post: Post) async throws {}
}
#endif
