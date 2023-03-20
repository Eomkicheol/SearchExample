//
//  Networking.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

import RxSwift
import Moya


public enum ApiError: Error {
    case noResponse
    case invalidData
    case unexpected
    case invalidRequest
}

extension ApiError: CustomStringConvertible {
    public var description: String {
        switch self {
            case .invalidData:
                return "잘못된 데이터가 입력되었습니다."
            case .noResponse:
                return "서버에 응답이 없습니다 잠시후 다시 이용해 주세요."
            case .unexpected:
                return "현재 일시적인 문제가 생겨 빠르게 개선중입니다.\n이용에 불편을 드려 죄송합니다.\n잠시 후 다시 접속해주세요."
            case .invalidRequest:
                return "잘못된 URL 요청 입니다."
        }
    }
}

public protocol NetworkType {
    func request<T: Codable>(_ target: TargetType) -> Single<T>
}

open class Network: NetworkType {
    public init() {}
    public func request<T>(_ target: TargetType) -> Single<T> where T : Decodable, T : Encodable {
        
        guard let request = createRequest(from: target) else {
            self.log("❌ Invalid request: \(target)")
            return Single.error(ApiError.invalidRequest)
        }
        
        self.log("🚀 Sending request: \(target.method.rawValue) \(target.path)")
        return Single.create { [weak self] single -> Disposable in
            guard let self = self else { return Disposables.create() }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    self.log("❌ Request failed: \(error)")
                    single(.failure(error))
                    return
                }
                
        
                guard let status = response as? HTTPURLResponse else {
                    self.log("❌ Unexpected response: \(response.debugDescription)")
                    single(.failure(ApiError.unexpected))
                    return
                }
                
                guard 200..<300 ~= status.statusCode else {
                    self.log("❌ Invalid status code: \(status.statusCode)")
                    single(.failure(ApiError.unexpected))
                    return
                }
                guard let data = data else {
                    self.log("❌ Response data is empty")
                    single(.failure(ApiError.unexpected))
                    return
                }
                
                guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                    self.log("❌ Invalid data: \(String(data: data, encoding: .utf8) ?? "")")
                    single(.failure(ApiError.invalidData))
                    return
                }
                
                self.log("✅ Request succeeded: \(String(data: data, encoding: .utf8) ?? "")")
                single(.success(decodeData))
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
            
        }
    }
    
    private func createRequest(from target: TargetType) -> URLRequest? {
        let url = target.baseURL.appendingPathComponent(target.path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let queryItems = target.queryItems {
            components.queryItems = queryItems.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let finalUrl = components.url else {
            return nil
        }
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.headers
        
        if let bodyData = target.body {
            request.httpBody = bodyData
        }
        
        return request
    }
    
    private func log(_ message: String) {
        print("[Network] \(message)")
    }
}
