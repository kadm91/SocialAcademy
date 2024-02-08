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
        .swipeActions {
            if vm.canDeleteComment {
                Button(role: .destructive) {
                    showConfirmationDialog.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .confirmationDialog("Are you sure you want to delete this comment?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: {
                vm.deleteComment()
            })
        }
    }
        
}

#Preview {
    CommentRow(vm: CommentRowViewModel(comment: Comment.testComment, deleteAction: { }))
        .previewLayout(.sizeThatFits)
}
