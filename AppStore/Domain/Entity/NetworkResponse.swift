//
//  NetworkResponse.swift
//  AppStore
//
//  Created by paytalab on 9/12/24.
//

import Foundation

public struct NetworkResponse<T: Decodable>: Decodable {
    let resultCount: Int
    let results: [T]
    
}
