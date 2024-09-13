//
//  AppListItem.swift
//  AppStore
//
//  Created by paytalab on 9/12/24.
//

import Foundation

public struct AppListItem: Decodable {
    let name: String
    let id: Int
    let iconUrl: String
    let userRatingCount: Int
    let averageUserRating: Double
    let genres: [String]
    let screenshotUrls: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case id = "trackId"
        case iconUrl = "artworkUrl100"
        case userRatingCount
        case averageUserRating
        case genres
        case screenshotUrls
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(Int.self, forKey: .id)
        self.iconUrl = try container.decode(String.self, forKey: .iconUrl)
        self.userRatingCount = try container.decode(Int.self, forKey: .userRatingCount)
        self.averageUserRating = try container.decode(Double.self, forKey: .averageUserRating)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.screenshotUrls = try container.decode([String].self, forKey: .screenshotUrls)
    }
}

