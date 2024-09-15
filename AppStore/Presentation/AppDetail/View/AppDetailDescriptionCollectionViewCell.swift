//
//  AppDetailDescriptionCollectionViewCell.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import UIKit
import RxSwift

final class AppDetailDescriptionCollectionViewCell: UICollectionViewCell, AppDetailCellProtocol {
    static let id = "AppDetailDescriptionCollectionViewCell"
    private let disposeBag = DisposeBag()
    private let border = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    private let descriptionLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 5
        return label
    }()
    private let showMoreButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    public var onExpanded: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(border)

        contentView.addSubview(descriptionLabel)
        contentView.addSubview(showMoreButton)
        setConstraints()
        showMoreButton.rx.tap.bind { [weak self] in
            self?.descriptionLabel.numberOfLines = 0
            self?.showMoreButton.isHidden = true
            self?.onExpanded?()
        }.disposed(by: disposeBag)
    }
    
    func apply(cellData: AppDetailCellData) {
        guard case let .description(description) = cellData else { return }
        descriptionLabel.text = description
    }
    private func setConstraints() {
        border.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        showMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
