//
//  PostsList.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/22/24.
//

import SwiftUI

struct PostsList: View {
    
    private var posts = [Post.testPost]
    
    var body: some View {
    
        NavigationStack {
            List(posts) { post in
                Text(post.content)
            }
            .navigationTitle("Posts")
        }
    }
}

#Preview {
    PostsList()
}
