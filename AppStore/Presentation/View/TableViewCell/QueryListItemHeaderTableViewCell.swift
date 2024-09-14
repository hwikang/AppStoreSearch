//
//  QueryListItemHeaderTableViewCell.swift
//  AppStore
//
//  Created by paytalab on 9/13/24.
//

import UIKit

final class QueryListItemHeaderTableViewCell: UITableViewCell, AppListCellProtocol {
    static let id = "QueryListItemHeaderTableViewCell"
    private let label = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let border = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(label)
        addSubview(border)
        border.backgroundColor = .systemGray6
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(16)
        }
        border.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func apply(cellData: AppListCellData) {
        guard case let .header(title) = cellData else { return }
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
