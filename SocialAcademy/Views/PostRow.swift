//
//  PostRow.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/23/24.
//
 
import SwiftUI

struct PostRow: View {
    
    @EnvironmentObject private var factory: ViewModelFactory
    
    typealias Action = () async throws -> Void
    
    @ObservedObject var vm: PostRowViewModel
    
    @State private var showConfirmationDialog = false
    @State private var showComments = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    
                    AuthorView(author: vm.author)
                    Spacer()
                    Text(vm.timestamp.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                }
                .foregroundColor(.gray)
                
                if let imageURL = vm.imageURL {
                    PostImage(url: imageURL)
                }
                
                Text(vm.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(vm.content)
                
                HStack {
                    
                    FavoriteButton(isFavorite: vm.isFavorite, action: { vm.favoritePost() })
                    
                    
                    
                    Button {
                        showComments.toggle()
                    } label: {
                        Label("Comments", systemImage: "text.bubble")
                            .font(.title3)
                    }
                    .foregroundStyle(Color.secondary)
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    if vm.canDeletePost {
                        Button(role: .destructive, action: {
                            showConfirmationDialog.toggle()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }

                }
                .labelStyle(.iconOnly)
                .padding(.top, 5)
                .sheet(isPresented: $showComments) {
                    CommentsList(vm: factory.makeCommentsViewModel(for: vm.post))
                }
               
                
                
            }
            .padding()
            .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                Button("Delete", role: .destructive, action: { vm.deletePost() })
            }
            .alert("Error", error: $vm.error)
        }
    
  
}

//MARK: - private extensions


private extension PostRow {
    struct AuthorView: View {
        
        let author: User
        
        @EnvironmentObject private var factory: ViewModelFactory
        
        var body: some View {
            NavigationLink {
                PostsList(vm: factory.makePostViewModel(filter: .author(author)))
            } label: {
                HStack {
                    ProfileImage(url: author.imageURL)
                        .frame(width: 40, height: 40)
                    Text(author.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
            }
        }
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
            .foregroundStyle(isFavorite ? .red : .secondary)
            .font(.title3)
            .animation(.default, value: isFavorite)
        }
    }
}


private extension PostRow {
    struct PostImage: View {
        let url: URL
        
        var body: some View {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                Color.clear
            }
        }
    }
}

//MARK: - Preview

#Preview {
    PostRow(vm: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
        .previewLayout(.sizeThatFits)
}
