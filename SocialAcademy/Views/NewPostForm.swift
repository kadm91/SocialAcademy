//
//  NewPostForm.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/23/24.
//

import SwiftUI

struct NewPostForm: View {
    
    @Environment (\.dismiss) private var dismiss
    
    typealias CreateAction = (Post) async throws-> Void
    let createAction: CreateAction
    
    @State private var state = FormState.idle
    @State private var post = Post()
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    postInfoSection
                }
                
                Section ("Content") {
                    postContetnSection
                }
                
                Section {
                    summitBtn
                }
               
                
            }
            .toolbar {
                ToolbarItem (placement: .topBarLeading){
                    Button("Dismiss", role: .cancel) {dismiss()}
                }
            }
            .navigationTitle(viewTitle)
            .onSubmit (createPost)
        }
        .disabled(state == .working)
        .alert("Cannot Create Post", isPresented: $state.isError, actions: {}) {
            Text("Sorry, something went wrong.")
        }
    }
}

//MARK: - extension

private extension NewPostForm {
    
    //MARK: - Views
    
    var viewTitle: String {
        "New Post"
    }
    
    var postInfoSection: some View {
        Group {
            TextField("Title", text: $post.title)
            TextField("Author Name", text: $post.authorName)
        }
    }
    
    var postContetnSection: some View {
        TextEditor (text: $post.content)
                .multilineTextAlignment(.leading)
    }
    
    var summitBtn: some View {
    
        Button (action: createPost) {
            if state == .working {
                ProgressView()
            } else {
                Text("Create Post")
            }
        }
        .font(.headline)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.accentColor)
        
    }
    
    
    
    //MARK: - Functions
    
    private func createPost() {
        
        Task {
            state = .working
            do {
                try await createAction(post)
                dismiss()
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
                state = .error
            }
        }
    }
    
    //MARK: - State
    
    enum FormState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else { return }
                self = .idle
            }
        }
    }
}

//MARK: - Preview

#Preview {
    NewPostForm(createAction: { _ in } )
}
