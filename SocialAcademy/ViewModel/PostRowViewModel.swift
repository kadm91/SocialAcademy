//
//  PostRowViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/31/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject {
    typealias Action = () async throws -> Void
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action
    private let favoriteAction: Action
    
    init(post: Post, deleteAction: @escaping Action, favoriteAction: @escaping Action) {
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
       withErrorHandlingTask(perform: deleteAction)
    }
    
    
     func favoritePost() {
         withErrorHandlingTask(perform: favoriteAction)
    }
    
    //MARK: - Methods
    
    private func withErrorHandlingTask(perform action: @escaping Action) {
        Task {
            do {
                try await action()
            } catch {
                print("[PostRowViewModel] Error: \(error)")
                self.error = error
            }
        }
    }
}
