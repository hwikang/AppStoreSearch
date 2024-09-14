//
//  AppListViewController.swift
//  AppStore
//
//  Created by paytalab on 9/12/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift


final class AppListViewController: UIViewController {

    private let viewModel: AppListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let appListTableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.register(QueryListItemTableViewCell.self, forCellReuseIdentifier: QueryListItemTableViewCell.id)
        tableView.register(QueryListItemHeaderTableViewCell.self, forCellReuseIdentifier: QueryListItemHeaderTableViewCell.id)
        tableView.register(FilteredQueryListItemTableViewCell.self, forCellReuseIdentifier: FilteredQueryListItemTableViewCell.id)
        tableView.register(AppListItemTableViewCell.self, forCellReuseIdentifier: AppListItemTableViewCell.id)

        
        return tableView
    }()
    private let searchTextField = {
        let textField = SearchTextField()
        textField.returnKeyType = .search
        return textField
    }()
    public init(viewModel: AppListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindView()
        bindViewModel()
    }

    private func setUI() {
        self.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(appListTableView)
        setConstraints()
    }
    
    private func bindViewModel() {
      
        let queryChange = searchTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
        let search = searchTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(searchTextField.rx.text.orEmpty).debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        let output = viewModel.transform(input: AppListViewModel.Input(queryChange: queryChange,
                                                          search: search))
        
        output.cellData
            .observe(on: MainScheduler.instance)
            .bind(to: appListTableView.rx.items) { tableView, indexPath, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: element.id) else { return UITableViewCell() }
            (cell as? AppListCellProtocol)?.apply(cellData: element)
            return cell
        }.disposed(by: disposeBag)
        
    }
    private func bindView() {
        searchTextField.rx.controlEvent(.editingDidBegin)
            .bind { [weak self] in
                self?.hideNavigationBar()
            }.disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
            .bind { [weak self] query in
                guard let self = self, query.isEmpty else {
                    self?.hideNavigationBar()
                    return
                }
                showNavigationBar()
            }.disposed(by: disposeBag)
        
        appListTableView.rx.modelSelected(AppListCellData.self).bind { [weak self] cellData in
            switch cellData {
            case .query(let query), .filteredQuery(let query):
                self?.searchTextField.text = query
                self?.view.endEditing(true)
                self?.searchTextField.sendActions(for: .editingDidEnd)
            case .app(let appItem):
                self?.pushAppDetailVC(id: appItem.id)
            default: return
            }
        }.disposed(by: disposeBag)
    }
    private func setConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        appListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.frame.origin.y = 0
        }
    }
    
    private func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            view.frame.origin.y = view.safeAreaInsets.top
        }
    }
    
    private func pushAppDetailVC(id: Int) {
        let appRP = AppRepository(network: AppNetwork(manager: NetworkManager()))
        let appDetailUC = AppDetailUsecase(repository: appRP)
        let appDetaulVM = AppDetailViewModel(usecase: appDetailUC, id: id)
        let appDetailVC = AppDetailViewController(viewModel: appDetaulVM)
        navigationController?.pushViewController(appDetailVC, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

