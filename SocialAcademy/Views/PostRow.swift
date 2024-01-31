//
//  PostRow.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/23/24.
//

import SwiftUI

struct PostRow: View {
    
    typealias DeleteAction = () async throws -> Void
    
    let post: Post
    let deleteAction: DeleteAction
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(post.authorName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(post.timestamp.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                }
                .foregroundColor(.gray)
                Text(post.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(post.content)
            }
            .padding(.vertical)
        }
}

#Preview {
    PostRow(post: Post.testPost, deleteAction: {})
}
