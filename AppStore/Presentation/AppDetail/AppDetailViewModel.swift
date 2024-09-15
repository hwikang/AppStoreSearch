//
//  AppDetailViewModel.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public protocol AppDetailViewModelProtocol {
    func transform(input: AppDetailViewModel.Input) -> AppDetailViewModel.Output
}

public struct AppDetailViewModel: AppDetailViewModelProtocol {
    private let usecase: AppDetailUsecaseProtocol
    private let id: Int
    private let disposeBag = DisposeBag()
    private let appDetail = BehaviorRelay<AppDetailItem?>(value: nil)
    private let error = PublishRelay<String>()

    
    public init(usecase: AppDetailUsecaseProtocol, id: Int) {
        self.usecase = usecase
        self.id = id
        fetchAppDetail()
    }
    
    public struct Input {
    }
    
    public struct Output {
        let snapshot: Observable<NSDiffableDataSourceSnapshot<AppDetailSecion, AppDetailCellData>>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let snapshot = appDetail.compactMap { $0 }.map(createSnapshot)
        return Output(snapshot: snapshot, error: error.asObservable())
    }
    
    private func createSnapshot(appDetail: AppDetailItem) -> NSDiffableDataSourceSnapshot<AppDetailSecion, AppDetailCellData> {
        
        var snapshot = NSDiffableDataSourceSnapshot<AppDetailSecion, AppDetailCellData>()
        snapshot.appendSections([.header, .releaseNote, .screenshot, .description])
        snapshot.appendItems([.header(imageURL: appDetail.iconUrl, title: appDetail.name,
                                      subtitle: appDetail.genres.first ?? "")], toSection: .header)
        snapshot.appendItems([.releaseNote(releaseNote: appDetail.releaseNotes, appVersion: appDetail.version, releaseDateString:  usecase.timeDifference(dateString: appDetail.currentVersionReleaseDate))], toSection: .releaseNote)
       
        let screenshotItems = appDetail.screenshotUrls.map { AppDetailCellData.screenshot(imageURL: $0) }
        snapshot.appendItems(screenshotItems, toSection: .screenshot)
        snapshot.appendItems([.description(description: appDetail.description)], toSection: .description)
        return snapshot
    }

    private func fetchAppDetail() {
        Task {
            let result = await usecase.fetchAppDetail(id: id)
            switch result {
            case .success(let appDetail):
                if let appDetail = appDetail.first {
                    self.appDetail.accept(appDetail)
                }
                
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    
}
