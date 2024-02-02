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
            NavigationStack {
                SignInForm(viewModel: authVM.makeSignInViewModel()) {
                    NavigationLink("Create Account") {
                        CreateAccountForm(viewModel: authVM.makeCreateAccountViewModel())
                    }
                }
            }
     
                            
            
        }
    }
}

//MARK: - CreateAccountForm

struct CreateAccountForm: View {
    @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.name)
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)
            Button("Create Account", action: viewModel.submit)
        }
        .navigationTitle("Create Account")
    }
}

//MARK: - SignInForm

struct SignInForm<Footer: View>: View {
    @StateObject var viewModel: AuthViewModel.SignInViewModel
    @ViewBuilder let footer: () -> Footer
    
    var body: some View {
        Form {
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)
            Button("Sign In", action: viewModel.submit)
            footer()
        }
        .navigationTitle("Sign In")
    }
}



//MARK: - Preview

#Preview {
    AuthView()
}
