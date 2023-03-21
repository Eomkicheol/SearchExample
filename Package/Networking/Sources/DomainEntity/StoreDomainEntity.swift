//
//  StoreDomainEntity.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation
import Entitys
import Common

public struct StoreDomainEntity: Hashable {
    
    public var thumbnail60Image: String
    public var thumbnamil100ImageURL: String
    public var trackId: Int
    public var trackName: String
    public var screenshotName: [String]?
    public var userRatingCount: Int
    public var averageUserRating: Float = 0.0
    public var appDescription: String
    public var releaseNotes: String
    public var releaseDate: String
    public var version: String
    public var description: String
    public var sellerName: String
    public var shortVerietyInfo : [AppShortVarietyInfoItem] = []
    public var infoItems: [AppDetailInfoItem] = []
    public var languageTypes: [Language] = []
    
   public init(item: AppStoreItem) {
        self.thumbnail60Image = item.artworkUrl60 ?? ""
        self.thumbnamil100ImageURL = item.artworkUrl100 ?? ""
        self.trackId = item.trackId
        self.trackName = item.trackName
        self.screenshotName = item.screenshotUrls.map { $0 ?? "" }
        self.userRatingCount = item.userRatingCount ?? 0
        self.averageUserRating = Float(item.averageUserRatingForCurrentVersion ?? 0.0)
        self.appDescription = item.genres.joined(separator: ",")
        self.releaseNotes = item.releaseNotes ?? ""
        self.releaseDate = item.currentVersionReleaseDate ?? ""
        self.version = "버전 \(item.version ?? "")"
        self.description = item.description ?? ""
        self.sellerName = item.sellerName ?? ""
        self.languageTypes =  item.languageCodesISO2A.map { Language(code: $0) }
        self.averageUserRating = Float(((item.averageUserRatingForCurrentVersion ?? .zero) * 10) / 10)
        self.shortVerietyInfo = self.makeShortInfoItem(item: item)
        self.infoItems = self.makeDetailInfoItems(item: item)
    }
    
    private func makeDetailInfoItems(item: AppStoreItem) -> [AppDetailInfoItem] {
        let lastIndex = item.languageCodesISO2A.count - 1
        let name = self.languageTypes.first?.name ?? ""
        var languageTitle = "\(name) 외 \(lastIndex)개"
        if lastIndex == .zero {
            languageTitle = name
        }
        return [
            AppDetailInfoItem(
                title: "제공자",
                subTitle: item.sellerName ?? "",
                description: nil
            ),
            AppDetailInfoItem(
                title: "크기",
                subTitle: convertToFileSize(item: item),
                description: nil
            ),
            AppDetailInfoItem(
                title: "카테고리",
                subTitle: item.genres.first ?? "",
                description: nil
            ),
            AppDetailInfoItem(
                title: "호환성",
                subTitle: "이 iPhone와(과) 호환",
                description: convertToAvailableDevices(item: item).joined(separator: "\n\n")
            ),
            AppDetailInfoItem(
                title: "언어",
                subTitle: "\(languageTitle)",
                description: lastIndex == .zero ? nil : convertToLanguages()
            )
        ]
    }
    
    private func makeShortInfoItem(item: AppStoreItem) -> [AppShortVarietyInfoItem] {
            let lastIndex = item.languageCodesISO2A.count - 1
            var language = "+ \(lastIndex)개 언어"

            if lastIndex == .zero {
                language = self.languageTypes.first?.name ?? ""
            }
            let ratingCount = self.userRatingCount

            return [
                AppShortVarietyInfoItem(
                    topDescription: "\(ratingCount.convertToRatingFormatter())개의 평가",
                    midDescription: "\(self.averageUserRating.roundToDecimal())",
                    bottomDescription: "",
                    type: .review),

                AppShortVarietyInfoItem(
                    topDescription: AppShortVarietyType.age.topText,
                    midDescription: item.contentAdvisoryRating ?? "",
                    bottomDescription: "세",
                    type: .age
                ),
                AppShortVarietyInfoItem(
                    topDescription: AppShortVarietyType.ranking.topText,
                    midDescription: "#1",
                    bottomDescription: item.genres[safe: 0] ?? "",
                    type: .ranking
                ),
                AppShortVarietyInfoItem(
                    topDescription: AppShortVarietyType.seller.topText,
                    midDescription: "",
                    bottomDescription: item.sellerName ?? "",
                    type: .seller
                ),
                AppShortVarietyInfoItem(
                    topDescription: AppShortVarietyType.language.topText,
                    midDescription: item.languageCodesISO2A[safe: 0] ?? "",
                    bottomDescription: "\(language)",
                    type: .language
                )
            ]
        }
    
    private func convertToFileSize(item: AppStoreItem) -> String {
            let fileSizeBytes = Double(item.fileSizeBytes ?? "") ?? 1.0
            let fileSize = String(round(fileSizeBytes / 1000000))
            return "\(fileSize)MB"
        }
        
        private func convertToAvailableDevices(item: AppStoreItem) -> [String] {
            let minimumOsVersion: String = item.minimumOsVersion ?? ""
            var supportedDevices: [String] = []
            item.supportedDevices.forEach {
                switch $0 {
                    case let device where device.contains("iPhone"):
                        supportedDevices.append("iPhone \niOS \(minimumOsVersion)이상 필요.")
                    case let device where device.contains("iPad"):
                        supportedDevices.append("iPad \niOS \(minimumOsVersion)이상 필요.")
                    case let device where device.contains("iPodTouch"):
                        supportedDevices.append("IPod Touch \niOS \(minimumOsVersion)이상 필요.")
                    default:
                        break
                }
            }
            return supportedDevices.uniqued()
        }
        
        private func convertToLanguages() -> String {
            return self.languageTypes
                .map { $0.name }
                .joined(separator: ", ")
        }
}


public struct AppShortVarietyInfoItem: Hashable {
    public let topDescription: String
    public let midDescription: String
    public let bottomDescription: String
    public let type: AppShortVarietyType
}

public struct AppDetailInfoItem: Hashable {
    public let title: String
    public let subTitle: String
    public let description: String?
}

// MARK: - ItemType
public enum AppShortVarietyType: Hashable {
    
    case review
    case age
    case ranking
    case seller
    case language
    
    var topText: String {
        switch self {
        case .age:
            return "연령"
        case .ranking:
            return "차트"
        case .seller:
            return "개발자"
        case .language:
            return "언어"
        default:
            return ""
        }
    }
}

public enum Language: Hashable {
    case KO
    case EN
    case JA
    case CN
    case UK
    case FI
    case AR
    case RU
    case IT
    case TR
    case FR
    case HR
    case ETC(code: String)
    
    public init(code: String) {
        switch code {
            case "KO":
                self = .KO
            case "EN":
                self = .EN
            case "JA":
                self = .JA
            case "CN":
                self = .CN
            case "UK":
                self = .UK
            case "FI":
                self = .FI
            case "AR":
                self = .AR
            case "RU":
                self = .RU
            case "IT":
                self = .IT
            case "TR":
                self = .TR
            case "FR":
                self = .FR
            case "HR":
                self = .HR
            default:
                self = .ETC(code: code)
        }
    }
    
    public var name: String {
        switch self {
            case .KO:
                return "한국어"
            case .EN:
                return "영어"
            case .JA:
                return "일본어"
            case .AR:
                return "아랍어"
            case .RU:
                return "러시아어"
            case .FR:
                return "프랑스어"
            case .TR:
                return "터키어"
            case .UK:
                return "우크라이나어"
            case .FI:
                return "핀란드어"
            case .HR:
                return "크로아티아어"
            case .IT:
                return "이탈리아어"
            case .CN:
                return "중국어"
            case let .ETC(code: code):
                return code
        }
    }
}
