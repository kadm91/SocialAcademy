//
//  FormViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/2/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject {
    
    typealias Action = (Value) async throws -> Void
    
    @Published var value: Value
    @Published var error: Error?
    
    private let action: Action
    
    //MARK: - Init
    
    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.action = action
    }
    
    //MARK: - dynamicMember
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value [keyPath: keyPath] = newValue}
    }
    
    //MARK: - Methods
    
    private func hangleSubmit() async {
        do {
            try await action(value)
        } catch {
            print("[FormViewModel] Cannot submit: \(error)")
            self.error = error
        }
    }
    
  nonisolated func submit() {
        Task {
         await hangleSubmit()
        }
    }
}
