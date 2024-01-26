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
            List(vm.posts) { post in
                if searchText.isEmpty || post.contains(searchText) {
                    PostRow(post: post)
                }
            }
            .toolbar {
              newPostBtn
            }
            .sheet(isPresented: $showNewPostForm) {
                NewPostForm(createAction: vm.makeCreateAction())
            }
            .navigationTitle("Posts")
            .overlay { noResultView }
            .searchable(text: $searchText)
        }
        .onAppear {
            vm.fetchPosts()
        }
    }
}

//MARK: - PostsList extension

private extension PostsList {
    
    var noResultView: some View {
        ForEach(vm.posts) { post in
            if !searchText.isEmpty && !post.contains(searchText) {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
    
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




