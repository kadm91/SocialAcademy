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
    
}


extension Loadable where Value: RangeReplaceableCollection {
    static var empty: Loadable<Value> { .loaded(Value())}
}
