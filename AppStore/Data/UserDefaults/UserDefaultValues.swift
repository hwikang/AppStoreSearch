//
//  UserDefaultValues.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation
public struct UserDefaultValues {
 
    @UserDefault(key: "queryList")
    public static var queryList: [String]?
    
}
@propertyWrapper
public struct UserDefault<Value> {
    let key: String

    public var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
