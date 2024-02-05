//
//  ViewModelFactory.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/5/24.
//

import Foundation

@MainActor
class ViewModelFactory: ObservableObject {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func makePostViewModel(filter: PostsViewModel.Filter = .all) -> PostsViewModel {
        return PostsViewModel(filter: filter, postsRepository: PostsRepository(user: user))
    }
}

#if DEBUG
extension ViewModelFactory {
    static let preview = ViewModelFactory(user: User.testUser)
}
#endif