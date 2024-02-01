//
//  PostsList.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/22/24.
//

import SwiftUI

struct PostsList: View {
    
    
    @StateObject var vm = PostsViewModel()
    
    @State private var searchText = ""
    @State private var showNewPostForm = false
   
    
    var body: some View {
        
        NavigationStack {
            postsList
            
                .toolbar {
                    newPostBtn
                }
                .sheet(isPresented: $showNewPostForm) {
                    NewPostForm(createAction: vm.makeCreateAction())
                }
            
                .navigationTitle(vm.title)
        }
        
        .onAppear {
            vm.fetchPosts()
        }
    }
}

//MARK: - PostsList extension

private extension PostsList {
    
    var postsList: some View {
        Group {
            switch vm.posts {
            case .loading:
                ProgressView()
            case let .error(error):
                errorView(message: error.localizedDescription)
            case .empty:
                emptyView
            case let .loaded(posts):
                
                List(posts) { post in
                    if searchText.isEmpty || post.contains(searchText) {
                        PostRow(vm: vm.makePostRowViewModel(for: post))
                    }
                }
                .searchable(text: $searchText)
                .animation(.default, value: posts)
               
                
            }
        }
        
    }
    
    var newPostBtn: some View {
        Button ("New Post", systemImage: "square.and.pencil") {
            showNewPostForm.toggle()
        }
    }
    
    func errorView(message: String) -> some View {
        ContentUnavailableView(
            label: {
                Label(
                    title: { Text("Cannot Load Posts") },
                    icon: { Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)  }
                )
            }, description: {
                Text(message)
            }, actions: {
                Button {
                    vm.fetchPosts()
                } label: {
                    Text("Try Again")
                        .bold()
                        .font(.headline)
                }
                
                .buttonStyle(.borderless)
                
            })
        
    }
    
    var emptyView: some View {
        ContentUnavailableView( vm.title == "Posts" ? "No Posts" : "No Favorite Posts", systemImage: vm.title == "Posts" ? "note" : "heart", description: vm.title == "Posts" ? Text("There aren't any Posts yet.") : Text("There aren't any favorite Posts yet"))
    }
    
    
    
    
    
}

//MARK: - Preview

#Preview {
    PostsList()
        
}

#if DEBUG

#Preview("Empty State") {
    
    do {
        let state: Loadable<[Post]> = .empty
        let postRepository = PostsRepositoryStub(state: state)
        let vm = PostsViewModel(postsRepository: postRepository)
        return PostsList(vm: vm)
        
    }
    
}

#Preview("Loaded State") {
    
    do {
        let state: Loadable<[Post]> = .loaded([Post.testPost])
        let postRepository = PostsRepositoryStub(state: state)
        let vm = PostsViewModel(postsRepository: postRepository)
        return PostsList(vm: vm)
        
    }
    
}

#Preview("Error State") {
    
    do {
        let state: Loadable<[Post]> = .error
        let postRepository = PostsRepositoryStub(state: state)
        let vm = PostsViewModel(postsRepository: postRepository)
        return PostsList(vm: vm)
    }
    
}

#Preview("Loading State") {
    
    do {
        let state: Loadable<[Post]> = .loading
        let postRepository = PostsRepositoryStub(state: state)
        let vm = PostsViewModel(postsRepository: postRepository)
        return PostsList(vm: vm)
    }
    
}

#endif




