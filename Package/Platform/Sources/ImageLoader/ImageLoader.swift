//
//  ImageLoader.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import UIKit

public protocol Cancellable {
    func cancel()
}

public class CancellableWrapper: Cancellable {
    var cancellable: Cancellable?
    private(set) var isCancelled: Bool = false
    
    public func cancel() {
        isCancelled = true
        cancellable?.cancel()
    }
}

extension URLSessionDataTask: Cancellable { }

public class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable {
        let key = NSString(string: url.absoluteString)
        
        if let cachedImage = cache.object(forKey: key) {
            completion(cachedImage)
            return CancellableWrapper()
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache.setObject(image, forKey: key)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        dataTask.resume()
        
        let cancellable = CancellableWrapper()
        cancellable.cancellable = dataTask
        return cancellable
    }
}

private var imageDownloadDataTaskKey: Void?

public extension UIImageView {
    var dataTask: Cancellable? {
        get {
            objc_getAssociatedObject(self, &imageDownloadDataTaskKey) as? Cancellable
        }
        set {
            dataTask?.cancel()
            objc_setAssociatedObject(self, &imageDownloadDataTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL) {
        dataTask = ImageLoader.shared.load(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
