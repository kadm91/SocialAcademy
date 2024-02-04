//
//  AuthViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/2/24.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    
    private let authService = AuthService()
    
    init() {
        authService.$isAuthenticated.assign(to: &$isAuthenticated)
    }
    
    //MARK: - Intentions
    
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email:password:))
    }
    
    func makeCreateAccountViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(action: authService.createAccount(name:email:password:))
    }
    
    
}

//MARK: - subclassing AuthViewModel

extension AuthViewModel {
    
    // signIn
    
    class SignInViewModel: FormViewModel<(email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (email: "", password: ""), action: action)
        }
    }
    
    
    // createAccount
    
    class CreateAccountViewModel: FormViewModel<(name: String, email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: ( name: "", email: "", password: ""), action: action)
        }
    }
    
    
     
    
}
