//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/04/05.
//

import Foundation

struct KeywordsStore {
      var keywords: [String]
    
    init(keywords: [String]) {
        self.keywords = keywords
    }
    
    mutating func add(keyword: String) {
        keywords.append(keyword)
    }
    
    mutating func remove() {
        keywords.removeAll()
    }
}
