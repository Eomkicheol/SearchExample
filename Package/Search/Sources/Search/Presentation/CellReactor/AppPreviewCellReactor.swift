//
//  AppPreviewCellReactor.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import ReactorKit
import RxSwift

public class AppPreviewCellReactor: Reactor, IdentityHashable {
        
    private enum Constants { }
    
    public let initialState: State
    
    public enum Action {}
    
    public enum Mutation {}

    public struct State {
        var items: String
    }
    
    var event: String {
        return self.currentState.items
    }
    
    init(items: String) {
        defer { _ = self.state }
        self.initialState = State(items: items)
    }
    
    deinit {
        print(self)
    }
}

