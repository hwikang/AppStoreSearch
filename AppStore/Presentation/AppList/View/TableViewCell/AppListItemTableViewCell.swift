//
//  AppListItemTableViewCell.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import UIKit
import Kingfisher

final class AppListItemTableViewCell: UITableViewCell, AppListCellProtocol {
    static let id = "AppListItemTableViewCell"
    private let appImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    private let appTitleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let screenshotStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private let starStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    private let ratingCountLabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    override func prepareForReuse() {
        super.prepareForReuse()
        screenshotStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        starStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(appImageView)
        contentView.addSubview(appTitleLabel)
        contentView.addSubview(starStackView)
        contentView.addSubview(ratingCountLabel)
        contentView.addSubview(screenshotStackView)
        appImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(20)
            make.width.height.equalTo(80)
        }
        appTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appImageView)
            make.leading.equalTo(appImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
        starStackView.snp.makeConstraints { make in
            make.top.equalTo(appTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(12)
            make.width.equalTo(68)
            make.leading.equalTo(appTitleLabel)
        }
        ratingCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(starStackView.snp.trailing)
            make.centerY.equalTo(starStackView)
        }
        screenshotStackView.snp.makeConstraints { make in
            make.top.equalTo(appImageView.snp.bottom).offset(20)
            make.leading.equalTo(appImageView)
            make.height.equalTo(200)
            make.trailing.equalTo(-20)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    func apply(cellData: AppListCellData) {
        guard case let .app(appItem) = cellData else { return }
        appTitleLabel.text = appItem.name

        appImageView.kf.setImage(with: URL(string: appItem.iconUrl))
        setScreenshot(screenshotUrls: appItem.screenshotUrls)
        setRatingCountLabel(count: appItem.userRatingCount)
        setStar(rating: appItem.averageUserRating)

    }
    
    private func setScreenshot(screenshotUrls: [String]) {

        screenshotUrls.prefix(3).forEach {
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: $0))
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            screenshotStackView.addArrangedSubview(imageView)
        }
    }
    
    private func setStar(rating: Double) {
        for i in 0..<5 {
            let currentValue = rating - Double(i)
            if currentValue >= 1 {
                let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
                imageView.tintColor = .systemGray
                starStackView.addArrangedSubview(imageView)
            } else if currentValue > 0 {
                let view = FillStarImageView(percentage: currentValue)
                starStackView.addArrangedSubview(view)
            } else {
                let imageView = UIImageView(image: UIImage(systemName: "star"))
                imageView.tintColor = .systemGray
                starStackView.addArrangedSubview(imageView)
            }
        }
    }
    
    private func setRatingCountLabel(count: Int) {
        if count >= 100000 {
            ratingCountLabel.text = "\(count / 10000)만"
        } else if count >= 10000 {
            ratingCountLabel.text = "\((Double(count) / 10000 * 10).rounded() / 10)만"
        } else if count >= 1000 {
            ratingCountLabel.text = "\((Double(count) / 1000 * 10).rounded() / 10)천"
        } else {
            ratingCountLabel.text = "\(count)"
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class FillStarImageView: UIView {
    let backgroundImageView = UIImageView(image: UIImage(systemName: "star"))
    let foregroundImageView = UIImageView(image: UIImage(systemName: "star.fill"))

    init(percentage: CGFloat) {
        super.init(frame: .zero)
        addSubview(backgroundImageView)
        addSubview(foregroundImageView)
        tintColor = .systemGray
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(12)
        }
        foregroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        applyPartialFill(to: foregroundImageView, percentage: percentage)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyPartialFill(to imageView: UIImageView, percentage: CGFloat) {
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: 12 * percentage, height: 12)
        maskLayer.backgroundColor = UIColor.black.cgColor
        imageView.layer.mask = maskLayer
    }
}
