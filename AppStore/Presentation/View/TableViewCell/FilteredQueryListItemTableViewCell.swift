//
//  FilteredQueryListItemTableViewCell.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import UIKit

final class FilteredQueryListItemTableViewCell: UITableViewCell, AppListCellProtocol {
    static let id = "FilteredQueryListItemTableViewCell"
    private let iconImageView = {
        let imageView = UIImageView(image: .init(systemName: "magnifyingglass"))
        imageView.tintColor = .systemGray
        return imageView
    }()
    private let label = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private let border = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(iconImageView)
        addSubview(label)
        addSubview(border)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalTo(label)
            make.width.height.equalTo(20)
        }
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
        border.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func apply(cellData: AppListCellData) {
        guard case let .filteredQuery(query) = cellData else { return }
        label.text = query
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
