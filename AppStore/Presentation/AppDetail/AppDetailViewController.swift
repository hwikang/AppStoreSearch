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
        collectionView.register(AppDetailReleaseNoteCollectionViewCell.self, forCellWithReuseIdentifier: AppDetailReleaseNoteCollectionViewCell.id)
        
        return collectionView
    }()
    private var diffableDataSource: UICollectionViewDiffableDataSource<AppDetailSecion, AppDetailCellData>?
    public init(viewModel: AppDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bindView()
        bindViewModel()
    }
    private func bindView() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: appCollectionView) { [weak self] collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.id, for: indexPath)
            (cell as? AppDetailCellProtocol)?.apply(cellData: item)
            
            if let cell = cell as? AppDetailDescriptionCollectionViewCell {
                cell.onExpanded = {self?.applySection(section: .description)}
                
            }
            if let cell = cell as? AppDetailReleaseNoteCollectionViewCell {
                cell.onExpanded = {self?.applySection(section: .releaseNote)}
            }
            return cell
        }
        
        diffableDataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id, for: indexPath)
            let section = self?.diffableDataSource?.sectionIdentifier(for: indexPath.section)
            var sectionTitle: String
            switch section {
            case .screenshot: sectionTitle = "미리 보기"
            case .releaseNote: sectionTitle = "새로운 기능"
            default :sectionTitle = ""
            }
            (headerView as? SectionHeaderView)?.apply(title: sectionTitle)
            return headerView
        }
    }
    
    private func applySection(section: AppDetailSecion) {
        if let sectionSnapshot = diffableDataSource?.snapshot(for: section) {
            diffableDataSource?.apply(sectionSnapshot, to: section)
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
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)

        super.viewWillDisappear(animated)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

