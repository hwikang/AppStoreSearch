//
//  AppDetailUsecase.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import Foundation

public protocol AppDetailUsecaseProtocol {
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError>

}

public struct AppDetailUsecase: AppDetailUsecaseProtocol {
    private let repository: AppRepositoryProtocol
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
        
    }

    public func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        return await repository.fetchAppDetail(id: id)
    }
    
}
