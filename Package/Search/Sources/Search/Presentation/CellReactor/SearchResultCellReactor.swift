//
//  SearchResultCellReactor.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import ReactorKit
import RxSwift
import DomainEntity


public class SearchResultCellReactor: Reactor, IdentityHashable {

    private enum Constants { }
    
    public let initialState: State
    
    public enum Action {}
    
    public enum Mutation {}
    
    public struct State {
       var items: StoreDomainEntity?
        var menuBarSection: [PreviewImageSection] {
            return [PreviewImageSection(identity: .image,
                                        items: items?.screenshotName?.prefix(3).map {
                PreviewImageSection.Item.image(AppPreviewCellReactor(items: $0 ))
            } ?? .init())]
        }
    }
    
    var event: StoreDomainEntity {
        return self.currentState.items ?? .init(item: .init())
    }
    
    
    
    init(items: StoreDomainEntity) {
        defer { _ = self.state }
        self.initialState = State(items: items)
    }
    
    deinit {
        print(self)
    }
}
