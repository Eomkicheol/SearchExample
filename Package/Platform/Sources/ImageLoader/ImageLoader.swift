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
        guard let cancellable = self.cancellable else { return }
        
        isCancelled = true
        cancellable.cancel()
    }
}

extension URLSessionDataTask: Cancellable { }

public class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable {
        let key = NSString(string: url.absoluteString)
        
        if let cachedImage = getCachedImage(forKey: key, completion: completion) {
            return cachedImage
        }
        
        return fetchData(from: url, forKey: key, completion: completion)
    }
    
    private func getCachedImage(forKey key: NSString, completion: @escaping (UIImage?) -> Void) -> Cancellable? {
        if let image = cache.object(forKey: key) {
            completion(image)
            return nil
        }
        return nil
    }
    
    private func fetchData(from url: URL, forKey key: NSString, completion: @escaping (UIImage?) -> Void) -> Cancellable {
        let cancellable = CancellableWrapper()
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.cache.setObject(image, forKey: key)
                completion(!cancellable.isCancelled ? image : nil)
            }
        }
        
        dataTask.resume()
        
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
