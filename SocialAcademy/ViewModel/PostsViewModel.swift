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
    var posts = [Post.testPost]
    
    //MARK: - intentions
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return {[weak self] post in
            try await PostsRepository.create(post)
            self?.posts.insert(post, at: 0)
        }
    }
}
