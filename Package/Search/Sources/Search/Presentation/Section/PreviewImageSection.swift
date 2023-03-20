//
//  PreviewImageSection.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import RxDataSources

public struct PreviewImageSection: Hashable {
    enum Identity: String {
        case image
    }
    let identity: Identity
    public var items: [Item]
}

extension PreviewImageSection: SectionModelType {
    public init(original: PreviewImageSection, items: [Item]) {
        self = PreviewImageSection(identity: original.identity, items: items)
    }
}

extension PreviewImageSection {
    public enum Item: Hashable {
        case image(AppPreviewCellReactor)
    }
}

extension PreviewImageSection.Item: IdentifiableType {
    public var identity: String {
        return "\(self.hashValue)"
    }
}

