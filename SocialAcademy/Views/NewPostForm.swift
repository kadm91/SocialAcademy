//
//  NewPostForm.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/23/24.
//

import SwiftUI

struct NewPostForm: View {
    
    @StateObject var vm: FormViewModel<Post>
    
    @Environment (\.dismiss) private var dismiss
    

    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    postInfoSection
                }
                
                ImageSection(imageURL: $vm.imageURL)
                
                Section ("Content") {
                    postContetnSection
                }
                
                Section {
                    summitBtn
                }
               
                
            }
            .onChange(of: vm.isWorking) { isWorking, _ in
                guard !isWorking, vm.error == nil else { return }
                dismiss()
            }
            .toolbar {
                ToolbarItem (placement: .topBarLeading){
                    Button("Dismiss", role: .cancel) {dismiss()}
                }
            }
            .navigationTitle(viewTitle)
            .onSubmit (vm.submit)
        }
        .disabled(vm.isWorking)
        .alert("Cannot Create Post", error: $vm.error)
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
            TextField("Title", text: $vm.title)
            
        }
    }
    
    var postContetnSection: some View {
        TextEditor (text: $vm.content)
                .multilineTextAlignment(.leading)
    }
    
    var summitBtn: some View {
    
        Button (action: vm.submit) {
            if vm.isWorking {
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
    
    // ImageSection View
    
    struct ImageSection: View {
        @Binding var imageURL: URL?
        
        var body: some View {
            Section("Image") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    EmptyView()
                }
                ImagePickerButton(imageURL: $imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
            }
        }
    }
}

//MARK: - Preview

#Preview {
    NewPostForm(vm: FormViewModel(initialValue: Post.testPost, action: { _ in }))
}
