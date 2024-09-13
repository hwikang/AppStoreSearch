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
    private let disposeBag = DisposeBag()

    let searchTextField = SearchTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.returnKeyType = .done
        self.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = .white
        
        setUI()
        bindView()
    }

    private func setUI() {
        view.addSubview(searchTextField)
        setConstraints()
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
            .bind { [weak self] in
                guard let self = self else { return }
                navigationController?.setNavigationBarHidden(false, animated: true)
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = self.view.safeAreaInsets.top
                }
            }.disposed(by: disposeBag)
    }
    private func setConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
}

