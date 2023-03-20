//
//  SearchSection.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import RxDataSources


public struct SearchSection: Hashable {
    enum Identity: Int {
        case result
        case keyword
        case empty
    }
    let identity: Identity
    public var items: [Item]
}

extension SearchSection: SectionModelType {
    public init(original: SearchSection, items: [Item]) {
        self = SearchSection(identity: original.identity, items: items)
    }
}

extension SearchSection {
    public enum Item: Hashable {
        case result(SearchResultCellReactor)
        case keyword(SearchKeywordCellReactor)
        case empty(EmptyCellReactor)
    }
}

extension SearchSection.Item: IdentifiableType {
    public var identity: String {
        return "\(self.hashValue)"
    }
}
