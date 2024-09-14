//
//  AppListViewController.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AppDetailViewController: UIViewController {
    
    private let viewModel: AppDetailViewModelProtocol
    private let disposeBag = DisposeBag()
    private lazy var appCollectionView = {
       
        let layout = UICollectionViewCompositionalLayout { index, _ in
            self.diffableDataSource?.sectionIdentifier(for: index)?.layoutSize
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
        collectionView.register(AppDetailHeaderCollectionViewCell.self, forCellWithReuseIdentifier: AppDetailHeaderCollectionViewCell.id)
        collectionView.register(AppDetailScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: AppDetailScreenshotCollectionViewCell.id)
        collectionView.register(AppDetailDescriptionCollectionViewCell.self, forCellWithReuseIdentifier: AppDetailDescriptionCollectionViewCell.id)

        
        return collectionView
    }()
    private var diffableDataSource: UICollectionViewDiffableDataSource<AppDetailSecion, AppDetailCellData>?
    public init(viewModel: AppDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        setUI()
        bindView()
        bindViewModel()
    }
    private func bindView() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: appCollectionView) { [weak self] collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.id, for: indexPath)
            (cell as? AppDetailCellProtocol)?.apply(cellData: item)
            if let cell = cell as? AppDetailDescriptionCollectionViewCell {
                cell.onExpanded = {
                    if let sectionSnapshot = self?.diffableDataSource?.snapshot(for: .description) {
                        self?.diffableDataSource?.apply(sectionSnapshot, to: .description)
                    }
                }
            }
            return cell
        }
        
        diffableDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.id, for: indexPath)
                
                (headerView as? SectionHeaderView)?.apply(title: "미리 보기")
                return headerView
            }
            return nil
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: AppDetailViewModel.Input())
        output.snapshot
            .observe(on: MainScheduler.instance)
            .bind { [weak self] snapshot in
                self?.diffableDataSource?.apply(snapshot)
            }.disposed(by: disposeBag)
        
        
    }
    private func setUI() {
      
        view.backgroundColor = .white
        view.addSubview(appCollectionView)
        setConstraints()
    }
    
    private func setConstraints() {
       
        appCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
