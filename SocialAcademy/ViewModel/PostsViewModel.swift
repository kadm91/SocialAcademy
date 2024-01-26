//
//  Posts
//  ViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/24/24.
//

import Foundation

@Observable
final class postsViewModel {
    
    //MARK: - Properties
    
    var posts: Loadable<[Post]> = .loading
    @ObservationIgnored private let postsRepository: PostsRepository
    
    init( postsRepository: PostsRepository = PostsRepository() ) {
        
        self.postsRepository = postsRepository
    }
    
    
    //MARK: - intentions
    
    // Create post
    func makeCreateAction() -> NewPostForm.CreateAction {
        return {[weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        }
    }
    
    // Fetch Posts
    func fetchPosts() {
        Task {
            do {
                posts =  .loaded( try await postsRepository.fetchPosts() )
            } catch {
                print("[PostsViewMOdel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
}
