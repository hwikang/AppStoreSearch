//
//  AppDetailUsecase.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import Foundation

public protocol AppDetailUsecaseProtocol {
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError>
    func timeDifference(dateString: String) -> String
}

public struct AppDetailUsecase: AppDetailUsecaseProtocol {
    private let repository: AppRepositoryProtocol
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
        
    }

    public func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        return await repository.fetchAppDetail(id: id)
    }
    
    public func timeDifference(dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let givenDate = dateFormatter.date(from: dateString) else {
            return ""
        }
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: givenDate, to: currentDate)
        
        if let day = components.day, day >= 1 && day <= 6 {
            return "\(day)일 전"
        }
        if let week = components.weekOfYear, week >= 1 && week <= 4 {
            return "\(week)주 전"
        }
        if let month = components.month, month >= 1 && month <= 11 {
            return "\(month)달 전"
        }
        if let year = components.year, year >= 1 {
            return "\(year)년 전"
        }
        return "1일 전"
    }
}
