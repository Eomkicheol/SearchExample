//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/04/05.
//

import Foundation

class SearchSectionMaker {
    func makeSectionItems(keywords: [String]) -> [SearchSection.Item] {
        
        let sectionItems = keywords.map { SearchSection.Item.keyword(
            SearchKeywordCellReactor(items: $0)
        )}
        
        if sectionItems.count == 0 {
            return sectionItems
        } else {
            return sectionItems
        }
    }
}

