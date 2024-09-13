//
//  AppRepositoryProtocol.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation

public protocol AppRepositoryProtocol {
    func getQueryList() -> [String]
    func saveQuery(query: String)
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError>
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError>
}
