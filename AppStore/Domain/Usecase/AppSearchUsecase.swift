//
//  AppSearchUsecase.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation
protocol AppSearchUsecaseProtocol {
    func getQueryList() -> [String]
    
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError>
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError>
}
public struct AppSearchUsecase: AppSearchUsecaseProtocol {
    private let repository: AppRepositoryProtocol
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
        
    }
    func getQueryList() -> [String] {
        repository.getQueryList()
    }
    
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError> {
        repository.saveQuery(query: term)
        return await repository.fetchAppList(term: term, limit: limit)
    }
    
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        return await repository.fetchAppDetail(id: id)
    }
    
}
