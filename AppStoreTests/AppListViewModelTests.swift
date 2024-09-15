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
    //리스트 타입 테스트
    func testListTypeChangesOnSearch() {
        let search = PublishSubject<String>()
        let queryChange = PublishSubject<String>()
        let input = AppListViewModel.Input(queryChange: queryChange.asObservable(), search: search.asObservable())
        
        _ = viewModel.transform(input: input)
        
        search.onNext("검색시작")
        XCTAssertEqual(viewModel.listType.value, .app)

    }
    
    func testListTypeChangesOnQueryChange() {
        let search = PublishSubject<String>()
        let queryChange = PublishSubject<String>()
        let input = AppListViewModel.Input(queryChange: queryChange.asObservable(), search: search.asObservable())
        
        _ = viewModel.transform(input: input)
        queryChange.onNext("카카오")
        
        XCTAssertEqual(viewModel.listType.value, .filteredQuery)
        
        
        queryChange.onNext("")
        XCTAssertEqual(viewModel.listType.value, .query)
    }

    //검색하면 최근검색어에 저장 테스트
    func testSearchTriggersSaveAndRefreshQueryList() {
        mockUsecase.queryList = ["네이버", "배달"]
        let searchQuery = "카카오"
        
        let search = PublishSubject<String>()
        let queryChange = PublishSubject<String>()
        
        let input = AppListViewModel.Input(queryChange: queryChange.asObservable(), search: search.asObservable())
     
        _ = viewModel.transform(input: input)
        
        search.onNext(searchQuery)
        
        let expectedList = ["카카오", "배달", "네이버"]
        XCTAssertEqual(viewModel.allQueryList.value, expectedList)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

}
