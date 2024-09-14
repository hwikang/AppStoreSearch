//
//  AppListViewModel.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol AppListViewModelProtocol {
    func transform(input: AppListViewModel.Input) -> AppListViewModel.Output
}

public struct AppListViewModel: AppListViewModelProtocol {
    private let fetchLimit = 40
    private let usecase: AppListUsecaseProtocol
    private let disposeBag = DisposeBag()
    
    private let listType = BehaviorRelay<ListType>(value: .query)
    private let allQueryList = BehaviorRelay<[String]>(value: [])
    private let filteredQueryList = BehaviorRelay<[String]>(value: [])
    private let appList = BehaviorRelay<[AppListItem]>(value: [])
    private let error = PublishRelay<String>()
    public init(usecase: AppListUsecaseProtocol) {
        self.usecase = usecase
        getQueryList()
    }
    
    public struct Input {
        let queryChange: Observable<String>
        let search: Observable<String>
    }
    
    public struct Output {
        let cellData: Observable<[AppListCellData]>
        let error: Observable<String>
    }
    
    private enum ListType {
        case query
        case filteredQuery
        case app
    }
    
    public func transform(input: Input) -> Output {
        input.search
            .filter({ !$0.isEmpty })
            .bind { searchQuery in
            print("searchQuery \(searchQuery)")
            fetchAppList(query: searchQuery)
            listType.accept(.app)
        }.disposed(by: disposeBag)
        input.queryChange.bind { query in
            print("query \(query)")

            if query.isEmpty {
                listType.accept(.query)
            } else {
                let filterList = allQueryList.value.filter { 
                    usecase.extractConsonant(from: $0).contains(usecase.extractConsonant(from: query))
                }
                filteredQueryList.accept(filterList)
                listType.accept(.filteredQuery)
            }
        }.disposed(by: disposeBag)
        
        let cellData = Observable.combineLatest(listType, appList, allQueryList, filteredQueryList).map(createCellData)
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func createCellData(listType: ListType, appList: [AppListItem], allQueryList: [String], filteredQueryList: [String]) -> [AppListCellData] {
        switch listType {
        case .app:
            return appList.map { AppListCellData.app($0) }
        case .filteredQuery:
            return filteredQueryList.map { AppListCellData.filteredQuery($0) }
        case .query:
            return  [AppListCellData.header("최근 검색어")] + allQueryList.map { AppListCellData.query($0) }
        }
    }
    
    private func fetchAppList(query: String) {
        saveAndRefreshQueryList(query: query)
        Task {
            let result = await usecase.fetchAppList(term: query, limit: fetchLimit)
            switch result {
            case .success(let appList):
                self.appList.accept(appList)
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func saveAndRefreshQueryList(query: String) {
        usecase.saveQueryList(query: query)
        getQueryList()
    }
    
    private func getQueryList() {
        let list = Array(usecase.getQueryList().reversed())
        allQueryList.accept(list)
    }
}

public enum AppListCellData {
    case header(String)
    case query(String)
    case filteredQuery(String)
    case app(AppListItem)
    
    var id: String {
        switch self {
        case .header: return QueryListItemHeaderTableViewCell.id
        case .app: return AppListItemTableViewCell.id
        case .filteredQuery: return FilteredQueryListItemTableViewCell.id
        case .query: return QueryListItemTableViewCell.id
        }
    }
}


public protocol AppListCellProtocol {
    func apply(cellData: AppListCellData)
}
