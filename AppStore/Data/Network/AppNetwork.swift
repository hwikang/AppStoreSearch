//
//  AppNetwork.swift
//  AppStore
//
//  Created by paytalab on 9/12/24.
//

import Foundation
public struct AppNetwork {
    private let manager: NetworkManager
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    public func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError> {
        let url = "https://itunes.apple.com/search?term=\(term)&country=kr&entity=software&limit=\(limit)"
        return await manager.fetchData(url: url, method: .get)
        
    }
    
    public func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        let url = "https://itunes.apple.com/lookup?id=\(id)&country=kr"
        return await manager.fetchData(url: url, method: .get)
    }
}
