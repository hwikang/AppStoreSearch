//
//  AppRepositoryMock.swift
//  AppStoreTests
//
//  Created by paytalab on 9/14/24.
//

import Foundation
@testable import AppStore

struct AppRepositoryMock: AppRepositoryProtocol {
    func getQueryList() -> [String] {
        []
    }
    
    func saveQuery(query: String) { }
    
    func fetchAppList(term: String, limit: Int) async -> Result<[AppStore.AppListItem], AppStore.NetworkError> {
        .success([])
    }
    
    func fetchAppDetail(id: Int) async -> Result<[AppStore.AppDetailItem], AppStore.NetworkError> {
        .success([])
    }
    
    
}
