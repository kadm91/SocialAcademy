//
//  Loadable.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 1/25/24.
//

import Foundation

enum Loadable<Value> {
    case loading
    case error(Error)
    case loaded(Value)
    
    var value: Value? {
        get {
            if case let .loaded(value) = self {
                return value
            }
            
            return nil
        }
        
        set {
            guard let newValue = newValue else { return }
            self =  .loaded(newValue)
        }
    }
    
}


extension Loadable where Value: RangeReplaceableCollection {
    static var empty: Loadable<Value> { .loaded(Value())}
}


extension Loadable: Equatable where Value: Equatable {
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.error(error1), .error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.loaded(value1), .loaded(value2)):
            return value1 == value2
        default:
            return false
        }
    }
}
