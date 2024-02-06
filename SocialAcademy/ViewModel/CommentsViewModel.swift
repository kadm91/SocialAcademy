//
//  CommentsViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/6/24.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    
    @Published var comments: Loadable<[Comment]> = .loading
    
    private let commentsRepository: CommentsRepositoryProtocol
    
    init( commentsRepository: CommentsRepositoryProtocol) {
        self.commentsRepository = commentsRepository
    }
    
    func fetchComments() {
        Task {
            do {
                comments = .loaded(try await commentsRepository.fetchComments())
            } catch {
                print("[CommentsViewModel] Cannot fetch comments: \(error)")
                comments = .error(error)
            }
        }
    }
}
