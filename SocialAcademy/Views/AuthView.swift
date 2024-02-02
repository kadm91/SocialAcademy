//
//  AuthView.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/2/24.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject var authVM = AuthViewModel()
    
    var body: some View {
        if authVM.isAuthenticated {
            MainTabView()
        } else {
            Form {
                TextField("Email", text: $authVM.email)
                SecureField("Password", text: $authVM.password)
                Button("Sign In", action: { authVM.signIn() })
            }
        }
    }
}

#Preview {
    AuthView()
}
