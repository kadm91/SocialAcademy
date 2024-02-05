//
//  PostRow.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/23/24.
//
 
import SwiftUI

struct PostRow: View {
    
    typealias Action = () async throws -> Void
    
    @ObservedObject var vm: PostRowViewModel
    
    @State private var showConfirmationDialog = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(vm.author.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(vm.timestamp.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                }
                .foregroundColor(.gray)
                Text(vm.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(vm.content)
                
                HStack {
                    FavoriteButton(isFavorite: vm.isFavorite, action: { vm.favoritePost() })
                    Spacer()
                    Button(role: .destructive, action: {
                        showConfirmationDialog.toggle()
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                
                
            }
            .padding(.vertical)
            .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                Button("Delete", role: .destructive, action: { vm.deletePost() })
            }
            .alert("Error", error: $vm.error)
        }
    
  
}


private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                if isFavorite {
                    Label("Remove from Favorites", systemImage: "heart.fill")
                } else {
                    Label("Add to Favorites", systemImage: "heart")
                }
            }
            .foregroundStyle(isFavorite ? .red : .gray)
            .animation(.default, value: isFavorite)
        }
    }
}

#Preview {
    PostRow(vm: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
}
