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
    func fetchPosts(by author: User)async throws -> [Post]
    var user: User {get}
}


struct PostsRepository: PostsRepositoryProtocol {
   
    
    
    let user: User
    
    var postsReference = Firestore.firestore().collection("posts_v3")
    
    let favoritesReference = Firestore.firestore().collection("favorites")
    
    // Fetch Posts by User
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("author.id", isEqualTo: author.id))
    }
    
    
    //createe
    
    func create(_ post: Post) async throws {
        var post = post
        if let imageFileURL = post.imageURL {
            post.imageURL = try await StorageFile
                .with(namespace: "posts", identifier: post.id.uuidString)
                .putFile(from: imageFileURL)
                .getDownloadURL()
        }
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    //Fetch
    
    func fetchAllPosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference)
        
    }
    
    // Fetch Favorite Posts
    
    func fetchFavoritePosts() async throws -> [Post] {
        
        let favorites = try await fetchFavorites()
        guard !favorites.isEmpty else { return [] }
        
       return try await postsReference
            .whereField("id", in: favorites.map(\.uuidString))
                  .order(by: "timestamp", descending: true)
                  .getDocuments(as: Post.self)
                  .map { post in
                      post.setting(\.isFavorite, to: true)
                  }
    }
    
    // Delete
    
    func delete(_ post: Post) async throws {
        precondition(canDelete(post))
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
        let image = post.imageURL.map(StorageFile.atURL(_:))
        try await image?.delete()
    }
    
    // Favorite
    
    func favorite(_ post: Post) async throws {
        
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        try await document.setData(from: favorite)
    }
    
    
    // Unfavorite
    func unfavorite(_ post: Post) async throws {
            let favorite = Favorite(postID: post.id, userID: user.id)
            let document = favoritesReference.document(favorite.id)
            try await document.delete()
    }
    
}


//MARK: - Post extension

private extension Post {
    func setting<T>(_ property: WritableKeyPath<Post, T>, to newValue: T) -> Post {
        var post = self
        post[keyPath: property] = newValue
        return post
    }
}

//MARK: - PostRepositoryProtocol extension

extension PostsRepositoryProtocol {
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
}


//MARK: - Model Favorites

extension PostsRepository {
    
    struct Favorite: Identifiable, Codable {
        
        var id: String {
            postID.uuidString + "-" + userID
        }
        let postID: Post.ID
        let userID: User.ID
    }
    
    func fetchFavorites() async throws -> [Post.ID] {
         return try await favoritesReference
            .whereField("userID", isEqualTo: user.id)
            .getDocuments(as: Favorite.self)
            .map(\.postID)
    }
    
    private func fetchPosts(from query: Query) async throws -> [Post] {
        
        let (post, favorites) = try await (query.order(by: "timestamp", descending: true)
            .getDocuments(as: Post.self), fetchFavorites())
        
        return post.map { post in
            post.setting(\.isFavorite, to: favorites.contains(post.id))
        }
        
        
    }
}

//MARK: - Posts Repository Stub

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    
    
    var user = User.testUser
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return [Post] ()
    }
    
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
