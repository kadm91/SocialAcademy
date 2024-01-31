//
//  PostsViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/24/24.
//

import Foundation


@MainActor
final class PostsViewModel: ObservableObject  {
    
    //MARK: - Properties
    
    @Published var posts: Loadable<[Post]> = .loading
    private let postsRepository: PostsRepositoryProtocol


    init( postsRepository: PostsRepositoryProtocol = PostsRepository() ) {
        
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

    
    // create PostRowViewModel
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        return PostRowViewModel(
            post: post,
            deleteAction: { [weak self] in
                    try await self?.postsRepository.delete(post)
                    self?.posts.value?.removeAll(where: {$0.id == post.id})
                    
                
            }, favoriteAction: { [weak self] in
            
                    let newValue = !post.isFavorite
                    try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
                    guard let index = self?.posts.value?.firstIndex(of: post) else { return }
                    self?.posts.value?[index].isFavorite = newValue
                
            }
        )
    }
    
    
    
    
}
