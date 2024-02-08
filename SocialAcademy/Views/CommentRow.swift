//
//  CommentRow.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/6/24.
//

import SwiftUI

struct CommentRow: View {
    
    @ObservedObject var vm: CommentRowViewModel
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(vm.author.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(vm.timestamp.formatted())
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Text(vm.content)
                .font(.headline)
                .fontWeight(.regular)
        }
        .padding(5)
        .alert("Cannot Delete Comment", error: $vm.error)
 // add a confirmation acction dont allow for the button to delete the comment in firestore if comment is deleted direclty from the swipe action it work fine
        .swipeActions {
            if vm.canDeleteComment {
                Button(role: .destructive) {
                 vm.deleteComment()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
        
}

#Preview {
    CommentRow(vm: CommentRowViewModel(comment: Comment.testComment, deleteAction: { }))
        .previewLayout(.sizeThatFits)
}
