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
        if let viewModelFactory = authVM.makeViewModelFactory() {
            MainTabView()
                .environmentObject(viewModelFactory)
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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        CustomForm {
            TextField("Name", text: $viewModel.name)
                .textContentType(.name)
                .textInputAutocapitalization(.words)
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $viewModel.password)
                .textContentType(.newPassword)
            
        } footer: {
            Button("Create Account", action: viewModel.submit)
                .buttonStyle(.primary)
            
            Button("Sign In", action: dismiss.callAsFunction )
                .padding()
        }
        .onSubmit (viewModel.submit)
        .alert("Cannot Create Account", error: $viewModel.error)
        .disabled(viewModel.isWorking)
    }
}

//MARK: - SignInForm

struct SignInForm<Footer: View>: View {
    @StateObject var viewModel: AuthViewModel.SignInViewModel
    @ViewBuilder let footer: () -> Footer
    
    var body: some View {
        
        CustomForm {
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
        } footer: {
            Button("Sign In", action: viewModel.submit)
                .buttonStyle(.primary)
            footer()
                .padding()
        }
        .onSubmit(viewModel.submit)
        .alert("Cannot Sign In", error: $viewModel.error)
        .disabled(viewModel.isWorking)
    }
}

//MARK: - FormView

struct CustomForm<Content: View, Footer: View>: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let footer: () -> Footer
    
    var body: some View {
        VStack {
            Text("Socialacademy")
                .font(.title.bold())
            content()
                .padding()
                .background(Color.secondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            footer()
        }
        .toolbar(.hidden, for: .navigationBar)
        .padding()
    }
}


//MARK: - Preview

#Preview ("Sign In Form") {
    AuthView()
}

#Preview ("Create Account Form" ){
    
    CreateAccountForm(viewModel: AuthViewModel.CreateAccountViewModel(action: {_ in }))
   
}
