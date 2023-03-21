//
//  SearchApi.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import Networking

public enum ApiError: Error {
    case message(String)
}

public enum SearchApi {
    case search(keyword: String, limit: Int)
}


extension SearchApi: TargetType {
    public var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    public var headers: [String : String] {
        return [:]
    }
    
    
    public var baseURL: URL {
        guard let url = URL(string: "https://itunes.apple.com") else { fatalError("Bad URL Request") }
        return url
    }
    
    public var path: String {
        return "/search"
    }
    
    public var body: Data? {
        return nil
    }
    
    
    public var queryItems: [String : Any]? {
        switch self {
            case let .search(keyword, limit):
                return ["term": keyword,
                        "country": "kr",
                        "entity": "software",
                        "limit": limit]
        }
    }
    
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .message(let message):
            return NSLocalizedString(message, comment: "serverError")
        }
    }
}
