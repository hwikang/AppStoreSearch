//
//  AppDetailScreenshotCollectionViewCell.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import UIKit

final class AppDetailScreenshotCollectionViewCell: UICollectionViewCell, AppDetailCellProtocol {
    static let id = "AppDetailScreenshotCollectionViewCell"
    
    private let screenshotView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(screenshotView)
        screenshotView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func apply(cellData: AppDetailCellData) {
        guard case let .screenshot(imageUrl) = cellData else { return }
        screenshotView.kf.setImage(with: URL(string: imageUrl))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
