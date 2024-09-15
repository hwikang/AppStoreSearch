//
//  AppDetailUseateTests.swift
//  AppStoreTests
//
//  Created by paytalab on 9/15/24.
//

import Foundation

import XCTest
@testable import AppStore

final class AppDetailUseateTests: XCTestCase {
    var usecase: AppDetailUsecase!
    override func setUp() {
        super.setUp()
        usecase = AppDetailUsecase(repository: AppRepositoryMock())
    }
    
    func testTimeDifferenceDays() {
        let dateString = ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)
        let result = usecase.timeDifference(dateString: dateString)
        XCTAssertEqual(result, "5일 전")
    }
    
    func testTimeDifferenceWeeks() {
        let dateString = ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .weekOfYear, value: -3, to: Date())!)
        let result = usecase.timeDifference(dateString: dateString)
        XCTAssertEqual(result, "3주 전")
    }
    
    func testTimeDifferenceMonths() {
        let dateString = ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .month, value: -2, to: Date())!)
        let result = usecase.timeDifference(dateString: dateString)
        XCTAssertEqual(result, "2달 전")
    }
    
    override func tearDown() {
        super.tearDown()
        usecase = nil
    }
}
