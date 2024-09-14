//
//  AppListCellData.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import Foundation

public enum AppListCellData {
    case header(String)
    case query(String)
    case filteredQuery(String)
    case app(AppListItem)
    
    var id: String {
        switch self {
        case .header: return QueryListItemHeaderTableViewCell.id
        case .app: return AppListItemTableViewCell.id
        case .filteredQuery: return FilteredQueryListItemTableViewCell.id
        case .query: return QueryListItemTableViewCell.id
        }
    }
}


public protocol AppListCellProtocol {
    func apply(cellData: AppListCellData)
}
