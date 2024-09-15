//
//  AppDetailSection.swift
//  AppStore
//
//  Created by paytalab on 9/14/24.
//

import UIKit

public enum AppDetailSecion: Hashable {
    case header
    case screenshot
    case description
    case releaseNote
    var layoutSize: NSCollectionLayoutSection {
        switch self {
        case .header:
            return defaultSection()
        case .screenshot:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(200), heightDimension: .absolute(360)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 0, leading: 20, bottom: 40, trailing: 20)
           
            section.boundarySupplementaryItems = [ defaultHeader()]
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case .description:
            return defaultSection()
        case .releaseNote:
            let section =  defaultSection()
            section.contentInsets = .init(top: 0, leading: 20, bottom: 40, trailing: 20)

            section.boundarySupplementaryItems = [defaultHeader()]

            return section
        }
    }
    
    private func defaultSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(150)))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section

    }
    
    private func defaultHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        return header
    }
}

public enum AppDetailCellData: Hashable {
    case header(imageURL: String, title: String, subtitle: String)
    case screenshot(imageURL: String)
    case description(description: String)
    case releaseNote(releaseNote: String, appVersion: String, releaseDateString: String)
    var id: String {
        switch self {
        case .header: return AppDetailHeaderCollectionViewCell.id
        case .screenshot: return AppDetailScreenshotCollectionViewCell.id
        case .description: return AppDetailDescriptionCollectionViewCell.id
        case .releaseNote: return AppDetailReleaseNoteCollectionViewCell.id
        }
    }
}
public protocol AppDetailCellProtocol {
    func apply(cellData: AppDetailCellData)
}
