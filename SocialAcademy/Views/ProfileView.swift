//
//  ProfileView.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/2/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @StateObject var vm: ProfileViewModel
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ProfileImage(url: vm.imageURL)
                    .frame(width: 200, height: 200)
                Spacer()
                Text(vm.name)
                    .font(.title2)
                    .bold()
                    .padding()
                ImagePickerButton(imageURL: $vm.imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
                Spacer()
                    
            }
            .alert("Error", error: $vm.error)
            .disabled(vm.isWorking)
            .navigationTitle("Profile")
            .toolbar {
                Button("Sign Out", action: {
                    vm.signOut()
                })
            }
        }
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel(user: User.testUser, authService: AuthService()))
}
