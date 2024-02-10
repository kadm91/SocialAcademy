//
//  FormViewModel.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/2/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject, StateManager {
    
    typealias Action = (Value) async throws -> Void
    
    @Published var value: Value
    @Published var error: Error?
    @Published var isWorking = false
    
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
    
  nonisolated func submit() {
      withStateManagingTask { [self] in
          try await action(value)
      }
    }
}
