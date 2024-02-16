//
//  Observable.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/25/24.
//

import Foundation

class Observable<ObservedType> {
    private var _value: ObservedType?
    
    var valueChanged: ((ObservedType?) -> Void)?
    
    public var value: ObservedType? {
        get {
            return _value
        }
        
        set {
            _value = newValue
            valueChanged?(_value)
        }
    }

    init(_ value: ObservedType?) {
        _value = value
    }
    
//    func bindingChanged(to newValue: ObservedType) {
//        _value = newValue
//    }
}
