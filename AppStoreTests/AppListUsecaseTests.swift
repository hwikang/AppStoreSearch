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
    //초성 추출 테스트
    func testExtractConsonant() {
        let text = "카카오뱅크"
        let expected = "ㅋㅋㅇㅂㅋ"
        
        let result = usecase.extractConsonant(from: text)
        
        XCTAssertEqual(result, expected)
    }
    
    override func tearDown() {
        super.tearDown()
        usecase = nil
    }
}
