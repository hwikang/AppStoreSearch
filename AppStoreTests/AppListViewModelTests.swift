//
//  AppListViewModelTests.swift
//  AppStoreTests
//
//  Created by paytalab on 9/14/24.
//

import XCTest
import RxSwift

@testable import AppStore

final class AppListViewModelTests: XCTestCase {
    var mockUsecase: AppListUsecaseMock!
    var viewModel: AppListViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockUsecase = AppListUsecaseMock()
        viewModel = AppListViewModel(usecase: mockUsecase)
        disposeBag = DisposeBag()

    }
    
    func testListTypeChangesOnSearch() {
        let search = PublishSubject<String>()
        let queryChange = PublishSubject<String>()
        let input = AppListViewModel.Input(queryChange: queryChange.asObservable(), search: search.asObservable())
        
        // When
        _ = viewModel.transform(input: input)
        
        // Test search behavior
        search.onNext("검색시작")
        
        // Then
        XCTAssertEqual(viewModel.listType.value, .app)

    }
    
    func testListTypeChangesOnQueryChange() {
        // Given
        let search = PublishSubject<String>()
        let queryChange = PublishSubject<String>()
        let input = AppListViewModel.Input(queryChange: queryChange.asObservable(), search: search.asObservable())
        
        // When
        _ = viewModel.transform(input: input)
        queryChange.onNext("카카오")
        
        // Then
        XCTAssertEqual(viewModel.listType.value, .filteredQuery)
        
        // When
        queryChange.onNext("")
        // Then
        XCTAssertEqual(viewModel.listType.value, .query)
    }

    //검색하면 최근검색어에 저장 테스트
    func testSearchTriggersSaveAndRefreshQueryList() {
        // Given
        mockUsecase.queryList = ["네이버", "배달"]
        let searchQuery = "카카오"
        
        let search = PublishSubject<String>()
        let queryChange = PublishSubject<String>()
        
        let input = AppListViewModel.Input(queryChange: queryChange.asObservable(), search: search.asObservable())
        
        // When
        _ = viewModel.transform(input: input)
        
        // Simulate a search event
        search.onNext(searchQuery)
        
        let expectedList = ["카카오", "배달", "네이버"]
        XCTAssertEqual(viewModel.allQueryList.value, expectedList)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

}
