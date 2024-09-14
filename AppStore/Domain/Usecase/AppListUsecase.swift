//
//  AppListUsecase.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation
public protocol AppListUsecaseProtocol {
    func getQueryList() -> [String]
    func saveQueryList(query: String)
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError>
    func extractConsonant(from text: String) -> String
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
        return await repository.fetchAppList(term: querySpacing(query: term),
                                             limit: limit)
    }
    
    public func extractConsonant(from text: String) -> String {
        
        let koreanConsonants = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]

        let koreamUnicodeStart: UInt32 = 44032
        let koreamUnicodeEnd: UInt32 = 55203
        let consonantOffset: UInt32 = 588
        var result = ""
        
        for scalar in text.unicodeScalars {
            let unicodeValue = scalar.value
            
            if unicodeValue >= koreamUnicodeStart && unicodeValue <= koreamUnicodeEnd {
                let index = Int((unicodeValue - koreamUnicodeStart) / consonantOffset)
                result += koreanConsonants[index]
            } else {
                result += String(scalar)
            }
        }
        return result
    }
    private func querySpacing(query: String) -> String {
        query.replacingOccurrences(of: " ", with: "+")
    }
}
