//
//  AppDetailReleaseNoteCollectionViewCell.swift
//  AppStore
//
//  Created by paytalab on 9/15/24.
//
import UIKit
import RxSwift

final class AppDetailReleaseNoteCollectionViewCell: UICollectionViewCell, AppDetailCellProtocol {
    static let id = "AppDetailReleaseNoteCollectionViewCell"
    private let disposeBag = DisposeBag()
    private let appVersionlabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    private let releaesDateLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    private let releaseNoteLabel = {
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
    private let border = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    public var onExpanded: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(appVersionlabel)
        contentView.addSubview(releaesDateLabel)

        contentView.addSubview(releaseNoteLabel)
        contentView.addSubview(showMoreButton)
        contentView.addSubview(border)
        setConstraints()
        showMoreButton.rx.tap.bind { [weak self] in
            self?.releaseNoteLabel.numberOfLines = 0
            self?.showMoreButton.isHidden = true
            self?.onExpanded?()
        }.disposed(by: disposeBag)
    }
    
    func apply(cellData: AppDetailCellData) {
        guard case let .releaseNote(releaseNote, appVersion, releaseDateString) = cellData else { return }
        appVersionlabel.text = "버전 \(appVersion)"
        releaesDateLabel.text = releaseDateString
        releaseNoteLabel.text = releaseNote
        
        hideButtonIfNeeded()
    }
    private func hideButtonIfNeeded() {
        layoutIfNeeded()
        showMoreButton.isHidden = releaseNoteLabel.frame.height <= 80
    }
    private func setConstraints() {
        
        appVersionlabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        releaesDateLabel.snp.makeConstraints { make in
            make.top.equalTo(appVersionlabel)
            make.trailing.equalToSuperview()
        }
        releaseNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(appVersionlabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        showMoreButton.snp.makeConstraints { make in
            make.top.equalTo(releaseNoteLabel.snp.bottom).offset(8)
            make.trailing.bottom.equalToSuperview()
        }
        border.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
