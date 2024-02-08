//
//  CommentsList.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/6/24.
//

import SwiftUI

struct CommentsList: View {
    
    @Environment (\.dismiss) private var dismiss
    @StateObject var vm: CommentsViewModel
    
    var body: some View {
        NavigationStack {
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
                    VStack(spacing: 0){
                        emptyView
                        
                        
                        NewCommentForm(formVm: vm.makeNewCommentViewModel())
                            .padding(.vertical)
                            .background(.thickMaterial)
                            
                            
                    }
                   
                        
                    
                case let .loaded(comments):
                    
                    VStack (spacing: 0) {
                        List(comments) { comment in
                            CommentRow(vm: vm.makeCommentRowViewModel(for: comment))
                        }
                        
                        .animation(.default, value: comments)
                        
                    
                        NewCommentForm(formVm: vm.makeNewCommentViewModel())
                            .padding(.vertical)
                            .background(.thickMaterial)
                            
                            
                    }
                    
                }
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
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

//MARK: - extensions

extension CommentsList {
    
    struct NewCommentForm: View {
        
        @ObservedObject var formVm: FormViewModel<Comment>
        @FocusState private var isCommentFocus: Bool
        
        var body: some View {
            HStack {
                TextField("Comment", text: $formVm.content)
                    .focused($isCommentFocus)
                    .textFieldStyle(.roundedBorder)
                Spacer()
                Button { 
                    formVm.submit()
                } label: {
                    if formVm.isWorking {
                        ProgressView()
                    } else {
                        Label("Post", systemImage: "paperplane")
                            .font(.title3)
                    }
                }
                .labelStyle(.iconOnly)
                .padding(.trailing)
            }
            .onAppear {
                isCommentFocus.toggle()
            }
            .alert("Cannot Post Comment", error: $formVm.error)
            .animation(.default, value: formVm.isWorking)
            .disabled(formVm.isWorking)
            .onSubmit(formVm.submit)
            .padding(.horizontal)
            
        }
    }
}


//MARK: - Previews

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
