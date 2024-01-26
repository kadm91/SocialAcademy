//
//  PostsList.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/22/24.
//

import SwiftUI

struct PostsList: View {
    
    @Environment (postsViewModel.self) var vm
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
    
        NavigationStack {
            
            Group {
                switch vm.posts {
                case .loading:
                    ProgressView()
                case .error(_):
                    Text("Cannot Load Posts")
                case .empty:
                    Text("No Posts")
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(post: post)
                        }
                    }
                    .searchable(text: $searchText)
                }
            }
            .toolbar {
              newPostBtn
            }
            .sheet(isPresented: $showNewPostForm) {
                NewPostForm(createAction: vm.makeCreateAction())
            }
            .navigationTitle("Posts")
            //.overlay { noResultView }
            .searchable(text: $searchText)
        }
        .onAppear {
            vm.fetchPosts()
        }
    }
}

//MARK: - PostsList extension

private extension PostsList {
    
    
 //   var noResultView: some View {
        
        
        
        
        
        
        
//        Group {
//            switch vm.posts {
//                
//            case let .loaded(posts):
//                ForEach(posts) { post in
//                    if !searchText.isEmpty && !post.contains(searchText) {
//                        ContentUnavailableView.search(text: searchText)
//                    }
//                }
//            
//            }
//        }
      
       
   // }
    
    var newPostBtn: some View {
        Button ("New Post", systemImage: "square.and.pencil") {
            showNewPostForm.toggle()
        }
    }
    
 
}

//MARK: - Preview

#Preview {
    PostsList()
        .environment(postsViewModel())
}




