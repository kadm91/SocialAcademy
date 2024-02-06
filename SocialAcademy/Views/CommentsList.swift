//
//  CommentsList.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/6/24.
//

import SwiftUI

struct CommentsList: View {
    @StateObject var vm: CommentsViewModel
    
    var body: some View {
        Group {
            switch vm.comments {
            case .loading:
                ProgressView()
                    .onAppear {
                        vm.fetchComments()
                    }
            case let .error(error):
                errorView(message: error.localizedDescription)
                
            case .empty:
               emptyView
                
            case let .loaded(comments):
                List(comments) { comment in
                    CommentRow(comment: comment)
                }
                .animation(.default, value: comments)
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}


//MARK: - extension

private extension CommentsList {
    func errorView(message: String) -> some View {
        ContentUnavailableView(
            label: {
                Label(
                    title: { Text("Cannot Comments") },
                    icon: { Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)  }
                )
            }, description: {
                Text(message)
            }, actions: {
                Button {
                    vm.fetchComments()
                } label: {
                    Text("Try Again")
                        .bold()
                        .font(.headline)
                }
                .buttonStyle(.borderless)
                
            })
        
    }
    
    var emptyView: some View {
        ContentUnavailableView( "No Comments",
            systemImage: "note",
            description: Text( "There aren't any Comments."))
    }
}

#Preview {
    NavigationStack {
        CommentsList(vm: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: .loaded([Comment.testComment]))))
    }
}

#if DEBUG

#Preview("Empty State") {
    
    do {
        let state: Loadable<[Comment]> = .empty
        let commentsRepository = CommentsRepositoryStub(state: state)
        let vm = CommentsViewModel(commentsRepository: commentsRepository )
        return NavigationStack { CommentsList(vm: vm) }
    }
    
}

#Preview("Loaded State") {
    
    do {
        let state: Loadable<[Comment]> = .loaded([Comment.testComment])
        let commentsRepository = CommentsRepositoryStub(state: state)
        let vm = CommentsViewModel(commentsRepository: commentsRepository )
        return NavigationStack { CommentsList(vm: vm) }
    }
    
}

#Preview("Error State") {
    
    do {
        let state: Loadable<[Comment]> = .error
        let commentsRepository = CommentsRepositoryStub(state: state)
        let vm = CommentsViewModel(commentsRepository: commentsRepository )
        return NavigationStack { CommentsList(vm: vm) }
    }
    
}

#Preview("Loading State") {
    
    do {
        let state: Loadable<[Comment]> = .loading
        let commentsRepository = CommentsRepositoryStub(state: state)
        let vm = CommentsViewModel(commentsRepository: commentsRepository )
        return NavigationStack { CommentsList(vm: vm) }
    }
    
}

#endif
