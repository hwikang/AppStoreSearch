//
//  AppSearchUsecase.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation
public protocol AppListUsecaseProtocol {
    func getQueryList() -> [String]
    func saveQueryList(query: String)
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError>
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError>
}
public struct AppListUsecase: AppListUsecaseProtocol {
    private let repository: AppRepositoryProtocol
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
        
    }
    public func getQueryList() -> [String] {
        repository.getQueryList()
    }
    public func saveQueryList(query: String) {
        repository.saveQuery(query: query)
    }
    
    public func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError> {
        return await repository.fetchAppList(term: term, limit: limit)
    }
    
    public func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        return await repository.fetchAppDetail(id: id)
    }
    
}
