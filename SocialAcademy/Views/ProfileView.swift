//
//  ProfileView.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/2/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out", action: {try! Auth.auth().signOut()})
    }
}

#Preview {
    ProfileView()
}
