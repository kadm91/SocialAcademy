//
//  PostsList.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/22/24.
//

import SwiftUI

struct PostsList: View {
    
    private var posts = [Post.testPost]
    @State private var searchText = ""
    
    var body: some View {
    
        NavigationStack {
            List(posts) { post in
                if searchText.isEmpty || post.contains(searchText) {
                    PostRow(post: post)
                }
            }
            .navigationTitle("Posts")
            .overlay { noResultView }
            .searchable(text: $searchText)
          
                
            
            
        }
    }
}

//MARK: - PostsList extension

extension PostsList {
    
    var noResultView: some View {
        ForEach(posts) { post in
            if !searchText.isEmpty && !post.contains(searchText) {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
}

//MARK: - Preview

#Preview {
    PostsList()
}
