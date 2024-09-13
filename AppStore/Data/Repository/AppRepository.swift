//
//  AppRepository.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation

struct AppRepository: AppRepositoryProtocol {
    private let network: AppNetwork
    init(network: AppNetwork) {
        self.network = network
    }
    
    public func getQueryList() -> [String] {
        UserDefaultValues.queryList ?? []
    }
    
    public func saveQuery(query: String) {
        if var currentValue = UserDefaultValues.queryList {
            currentValue.append(query)
            UserDefaultValues.queryList = currentValue
        }
    }
    
    
    public func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError> {
        return await network.fetchAppList(term: term, limit: limit)
    }
    
 
    public func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        return await network.fetchAppDetail(id: id)
    }
}
