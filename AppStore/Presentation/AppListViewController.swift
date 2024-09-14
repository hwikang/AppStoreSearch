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
import Alamofire

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
        return tableView
    }()
    private let searchTextField = SearchTextField()
    public init(viewModel: AppListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.returnKeyType = .search
        self.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = .white
        
        setUI()
        bindView()
        bindViewModel()
    }

    private func setUI() {
        view.addSubview(searchTextField)
        view.addSubview(appListTableView)
        setConstraints()
    }
    
    private func bindViewModel() {
      
        let queryChange = searchTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
        let search = searchTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: AppListViewModel.Input(queryChange: queryChange,
                                                          search: search))
        
        output.cellData.bind(to: appListTableView.rx.items) { tableView, indexPath, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: element.id) else { return UITableViewCell() }
            (cell as? AppListCellProtocol)?.apply(cellData: element)
            return cell
        }.disposed(by: disposeBag)
        
    }
    private func bindView() {
        searchTextField.rx.controlEvent(.editingDidBegin)
            .bind { [weak self] in
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
                UIView.animate(withDuration: 0.3) {
                    self?.view.frame.origin.y = 0
                }
            }.disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
            .bind { [weak self] query in
                guard let self = self, query.isEmpty else { return }
                navigationController?.setNavigationBarHidden(false, animated: true)
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = self.view.safeAreaInsets.top
                }
            }.disposed(by: disposeBag)
        
        appListTableView.rx.modelSelected(AppListCellData.self).bind { [weak self] cellData in
            switch cellData {
            case .query(let query), .filteredQuery(let query):
                print(query)
                self?.searchTextField.text = query
                self?.searchTextField.sendActions(for: .editingDidEnd)
            case .app(let appItem):
                print(appItem)
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

