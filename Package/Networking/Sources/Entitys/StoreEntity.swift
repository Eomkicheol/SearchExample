//
//  StoreEntity.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

public struct StoreEntity: Codable, Hashable {
    public let resultCount: Int
    public let items: [AppStoreItem]
    
    public enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case items = "results"
    }
    
    public init(resultCount: Int, items: [AppStoreItem]) {
        self.resultCount = resultCount
        self.items = items
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resultCount = try container.decode(Int.self, forKey: .resultCount)
        self.items = try container.decode([AppStoreItem].self, forKey: .items)
    }
}

public struct AppStoreItem: Codable, Hashable {
    
    public let artworkUrl60: String?
    public let artworkUrl100: String?
    public let trackId: Int
    public let trackName: String
    public let genres: [String]
    public let screenshotUrls: [String?]
    public let userRatingCount: Int?
    public let contentAdvisoryRating: String?
    public let languageCodesISO2A: [String]
    public let sellerName: String?
    public let releaseNotes: String?
    public let version: String?
    public let currentVersionReleaseDate: String?
    public let description: String?
    public let fileSizeBytes: String?
    public let minimumOsVersion: String?
    public let supportedDevices: [String]
    public let averageUserRatingForCurrentVersion: Double?
    
    public enum CodingKeys: String, CodingKey {
       case artworkUrl60
       case artworkUrl100
       case trackId
       case trackName
       case genres
       case screenshotUrls
       case userRatingCount
       case contentAdvisoryRating
       case languageCodesISO2A
       case sellerName
       case releaseNotes
       case version
       case currentVersionReleaseDate
       case description
       case fileSizeBytes
       case minimumOsVersion
       case supportedDevices
       case averageUserRatingForCurrentVersion
    }
    
    public init(artworkUrl60: String?, artworkUrl100: String?, trackId: Int,
                trackName: String, genres: [String], screenshotUrls: [String?],
                userRatingCount: Int?, contentAdvisoryRating: String?, languageCodesISO2A: [String],
                sellerName: String?, releaseNotes: String?, version: String?,
                currentVersionReleaseDate: String?, description: String?, fileSizeBytes: String?,
                minimumOsVersion: String?, supportedDevices: [String], averageUserRatingForCurrentVersion: Double?) {
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.trackId = trackId
        self.trackName = trackName
        self.genres = genres
        self.screenshotUrls = screenshotUrls
        self.userRatingCount = userRatingCount
        self.contentAdvisoryRating = contentAdvisoryRating
        self.languageCodesISO2A = languageCodesISO2A
        self.sellerName = sellerName
        self.releaseNotes = releaseNotes
        self.version = version
        self.currentVersionReleaseDate = currentVersionReleaseDate
        self.description = description
        self.fileSizeBytes = fileSizeBytes
        self.minimumOsVersion = minimumOsVersion
        self.supportedDevices = supportedDevices
        self.averageUserRatingForCurrentVersion = averageUserRatingForCurrentVersion
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60)
        self.artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100)
        self.trackId = try container.decode(Int.self, forKey: .trackId)
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.screenshotUrls = try container.decodeIfPresent([String].self, forKey: .screenshotUrls) ?? []
        self.userRatingCount = try container.decodeIfPresent(Int.self, forKey: .userRatingCount)
        self.contentAdvisoryRating = try container.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
        self.languageCodesISO2A = try container.decodeIfPresent([String].self, forKey: .languageCodesISO2A) ?? []
        self.sellerName = try container.decodeIfPresent(String.self, forKey: .sellerName)
        self.releaseNotes = try container.decodeIfPresent(String.self, forKey: .releaseNotes)
        self.version = try container.decodeIfPresent(String.self, forKey: .version)
        self.currentVersionReleaseDate = try container.decodeIfPresent(String.self, forKey: .currentVersionReleaseDate)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.fileSizeBytes = try container.decodeIfPresent(String.self, forKey: .fileSizeBytes)
        self.minimumOsVersion = try container.decodeIfPresent(String.self, forKey: .minimumOsVersion)
        self.supportedDevices = try container.decode([String].self, forKey: .supportedDevices)
        self.averageUserRatingForCurrentVersion = try container.decodeIfPresent(Double.self, forKey: .averageUserRatingForCurrentVersion)
    }
}


extension AppStoreItem {
    public init() {
        self.artworkUrl60 = nil
        self.artworkUrl100 = nil
        self.trackId = 0
        self.trackName = ""
        self.genres = []
        self.screenshotUrls = []
        self.userRatingCount = nil
        self.contentAdvisoryRating = nil
        self.languageCodesISO2A = []
        self.sellerName = nil
        self.releaseNotes = nil
        self.version = nil
        self.currentVersionReleaseDate = nil
        self.description = nil
        self.fileSizeBytes = nil
        self.minimumOsVersion = nil
        self.supportedDevices = []
        self.averageUserRatingForCurrentVersion = nil
    }
}
