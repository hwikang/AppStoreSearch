//
//  AppUsecaseMock.swift
//  AppStoreTests
//
//  Created by paytalab on 9/14/24.
//

import Foundation
@testable import AppStore

class AppListUsecaseMock: AppListUsecaseProtocol {
    var queryList: [String] = []

    func getQueryList() -> [String] {
        queryList
    }
    
    func saveQueryList(query: String) {  queryList.append(query) }
    
    func fetchAppList(term: String, limit: Int) async -> Result<[AppStore.AppListItem], AppStore.NetworkError> {
        .success([])
    }
    
    func extractConsonant(from text: String) -> String {
        text
    }
    
    
}
