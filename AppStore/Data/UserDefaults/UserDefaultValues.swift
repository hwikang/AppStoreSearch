//
//  UserDefaultValues.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation
public struct UserDefaultValues {
 
    @UserDefault(key: "queryList", defaultValue: [])
    public static var queryList: [String]
    
}
@propertyWrapper
public struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    public var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
