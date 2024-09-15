//
//  AppDetailItem.swift
//  AppStore
//
//  Created by paytalab on 9/12/24.
//

import Foundation

public struct AppDetailItem: Decodable {
    let name: String
    let id: Int
    let iconUrl: String
    let userRatingCount: Int
    let averageUserRating: Double
    let genres: [String]
    let screenshotUrls: [String]
    let releaseNotes: String
    let description: String
    let sellerUrl: String?
    let trackViewUrl: String
    let artistName: String
    let trackContentRating: String
    let version: String
    let currentVersionReleaseDate: String
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case id = "trackId"
        case iconUrl = "artworkUrl100"
        case userRatingCount
        case averageUserRating
        case genres
        case screenshotUrls
        case releaseNotes
        case description
        case sellerUrl
        case trackViewUrl
        case artistName
        case trackContentRating
        case version
        case currentVersionReleaseDate
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
        self.releaseNotes = try container.decode(String.self, forKey: .releaseNotes)
        self.description = try container.decode(String.self, forKey: .description)
        self.sellerUrl = try container.decodeIfPresent(String.self, forKey: .sellerUrl)
        self.trackViewUrl = try container.decode(String.self, forKey: .trackViewUrl)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.trackContentRating = try container.decode(String.self, forKey: .trackContentRating)
        self.version = try container.decode(String.self, forKey: .version)
        self.currentVersionReleaseDate = try container.decode(String.self, forKey: .currentVersionReleaseDate)
    }
}

