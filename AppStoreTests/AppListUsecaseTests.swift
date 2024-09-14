//
//  AppListUsecaseTests.swift
//  AppStoreTests
//
//  Created by paytalab on 9/14/24.
//

import XCTest
@testable import AppStore

final class AppListUsecaseTests: XCTestCase {
    var usecase: AppListUsecase!
    override func setUp() {
        super.setUp()
        usecase = AppListUsecase(repository: AppRepositoryMock())
    }
    
    func testExtractConsonant() {
        // Given
        let text = "카카오뱅크"
        let expected = "ㅋㅋㅇㅂㅋ"
        
        // When
        let result = usecase.extractConsonant(from: text)
        
        // Then
        XCTAssertEqual(result, expected)
    }
    override func tearDown() {
        super.tearDown()
        usecase = nil
    }
}
