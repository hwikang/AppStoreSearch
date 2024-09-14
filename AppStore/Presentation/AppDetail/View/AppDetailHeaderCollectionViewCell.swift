//
//  AppDetailHeaderTableViewCell.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import UIKit

final class AppDetailHeaderCollectionViewCell: UICollectionViewCell, AppDetailCellProtocol {
    static let id = "AppDetailHeaderCollectionViewCell"
    private let appImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    private let appTitleLabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let subtitleLabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let border = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(appImageView)
        contentView.addSubview(appTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(border)

        appImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(120)
        }
        appTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appImageView)
            make.leading.equalTo(appImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(appTitleLabel)
        }
        border.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
   
    
    func apply(cellData: AppDetailCellData) {
        guard case let .header(imageURL, title, subtitle) = cellData else { return }
        appTitleLabel.text = title
        subtitleLabel.text = subtitle
        appImageView.kf.setImage(with: URL(string: imageURL))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
