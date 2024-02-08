//
//  CommentRowViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/7/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject {
    
    typealias Action = () async throws -> Void
    
    private let deleteAction: Action?
    var canDeleteComment: Bool { deleteAction != nil}
    
    @Published var comment: Comment
    @Published var error: Error?
    
    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }
    
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannont delete comment: no delete action provided")
        }
        
        Task {
            do {
                try await deleteAction()
            } catch {
                print("[CommentRowViewModel] Cannot delete comment: \(error)")
                self.error = error
            }
        }
    }
    

}
