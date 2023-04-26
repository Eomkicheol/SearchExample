//
//  SearchReactor.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import ReactorKit
import RxSwift
import Utils

import DomainEntity
import Networking


public enum SearchState {
    case historyAll
    case historyFilter
    case result
    case removeAll
}

final class SearchReactor: Reactor {
    
    private enum Constants {
        static let itemCount: Int = 50
    }
    
    
    let initialState: State = State()
    
    var previousList: [String] = []
    
    
    // var keywordStore...
    
    // keywordStore.toSections()
    
    let useCase: SearchUseCase
    
    let maker: SearchSectionMaker
    
    init(useCase: SearchUseCase, maker: SearchSectionMaker) {
        self.useCase = useCase
        self.maker = maker
    }
    
    deinit {
        print(self)
    }
    
    enum Action {
        case searchHistoryAll
        case searchText(keyword: String)
        case updateSearchText(keyword: String)
        case removeAll
        case selectedItem(StoreDomainEntity)
    }
    
    struct State {
        @Pulse var type: SearchState?
        @Pulse var isErrorMessage: String?
        var searchSection: [SearchSection] = []
        @Pulse var selectedItem: StoreDomainEntity?
        @Pulse var removeSearchKeyword: String?
        var totalCount: Int = 0
    }
    
    enum Mutation {
        case setType(SearchState)
        case setHistoryAll(previousList: [String])
        case setHistoryFilter(filterList: [String])
        case restorePreviousSearch(searchList: [String])
        case setHistoryRemoveAll(String?)
        case setSearchKeyword([StoreDomainEntity])
        case setErrorMessage(String)
        case setSelectedItem(StoreDomainEntity)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchHistoryAll:
            return self.setHistoryKeywordAllMutation()
            
        case let .searchText(keyword):
            return self.setSearchKeywordMutation(keyword: keyword)
            
        case let .updateSearchText(keyword):
            return self.setHistoryKeywordFilterMutation(keyword: keyword)
            
        case .removeAll:
            return self.searchKeywordRemoveAllMutation()
            
        case let .selectedItem(value):
            return self.setSelectedItemMutation(with: value)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSearchKeyword(value):
            newState = self.searchReduce(state: newState, previousList: [], items: value)
            
        case let .setErrorMessage(message):
            newState = self.errorMessageReduce(state: newState, message: message)
            
        case let .setHistoryAll(previousList):
            newState = self.searchReduce(state: newState, previousList: previousList, items: nil)
            
        case let .setHistoryFilter(filterList):
            newState = self.searchReduce(state: newState, previousList: filterList, items: nil)
            
        case let .setHistoryRemoveAll(keyword):
            newState = self.searchKeyRemoveAllReduce(state: newState, keyword: keyword)
            
        case let .setType(type):
            newState = self.searchTypeReduce(state: newState, type: type)
            
        case let .setSelectedItem(value):
            newState = self.searchSelectedItemReduce(state: newState, item: value)
            
        case let .restorePreviousSearch(value):
            newState = self.restorePreviousSearchReduce(state: newState, searchList: value)
        }
        return newState
    }
}

// MARK: Mutation
extension SearchReactor {
    private func setHistoryKeywordAllMutation() -> Observable<Mutation> {
        return Observable.concat([
            Observable.just(Mutation.setType(.historyAll)),
            Observable.just(Mutation.setHistoryAll(previousList: self.previousList.reversed()))
        ])
    }
    
    private func setSearchKeywordMutation(keyword: String) -> Observable<Mutation> {
        self.previousList = self.useCase.updateSearchKeyword(keyword: keyword, previousList: self.previousList)
        
        let search = self.useCase.fetchSearchKeyword(with: keyword, limit: Constants.itemCount)
            .flatMap { Observable.just(Mutation.setSearchKeyword($0) )}
            .catch { error -> Observable<Mutation> in
                guard let error = error as? ApiError else { return .empty() }
                return Observable.just(Mutation.setErrorMessage(error.description))
            }
        
        return Observable.concat([
            Observable.just(Mutation.setType(.result)),
            search
        ])
    }
    
    private func setHistoryKeywordFilterMutation(keyword: String) ->  Observable<Mutation> {
        self.previousList = self.useCase.fetchSearchKeywords()
    
        let filterList = self.previousList.filter { $0.localizedStandardContains(keyword)}
        
        return Observable.concat([
            Observable.just(Mutation.setType(.historyFilter)),
            Observable.just(Mutation.setHistoryFilter(filterList: filterList.reversed()))
        ])
    }
    
    private func searchKeywordRemoveAllMutation() -> Observable<Mutation> {
        self.previousList = self.useCase.fetchSearchKeywords()
        
        return Observable.concat([
            Observable.just(Mutation.setType(.removeAll)),
            Observable.just(Mutation.setHistoryRemoveAll("")),
            Observable.just(Mutation.setHistoryRemoveAll(nil)),
            Observable.just(Mutation.restorePreviousSearch(searchList: self.previousList))
        ])
    }
    
    private func setSelectedItemMutation(with item: StoreDomainEntity) -> Observable<Mutation> {
        return Observable.just(Mutation.setSelectedItem(item))
    }
}

// MARK: Reduce
extension SearchReactor {
    private func searchReduce(state: State, previousList: [String], items: [StoreDomainEntity]?) -> State {
        var newState = state
        
        switch self.currentState.type {
            
        case .historyAll, .historyFilter:
            
            let sectionItems = previousList.map { SearchSection.Item.keyword(
                SearchKeywordCellReactor(items: $0)
            )}
            
            newState.searchSection = [
                SearchSection(identity: .keyword, items: sectionItems)
            ]
            
        case .result:
            guard let searchModel = items else { return newState }
            newState = searchResultReduce(state: newState, items: searchModel)
        default:
            break
        }
        return newState
    }
    
    private func searchResultReduce(state: State, items: [StoreDomainEntity]) -> State {
        var newState = state
        newState.totalCount = items.count
        
        
        if items.count > 0 {
            let sectionItems = items.map { SearchSection.Item.result(SearchResultCellReactor(items: $0) )}
            
            newState.searchSection = [
                SearchSection(identity: .result, items: sectionItems)
            ]
            
        } else {
            newState = searchNoDataReduce(state: newState)
        }
        return newState
    }
    
    private func searchNoDataReduce(state: State) -> State {
        var newState = state
        let sectionItems = SearchSection.Item.empty(EmptyCellReactor(items: "검색 결과가 없습니다."))
        
        newState.searchSection = [
            SearchSection(identity: .empty, items: [sectionItems])
        ]
        return newState
    }
    
    private func searchKeyRemoveAllReduce(state: State, keyword: String?) -> State {
        var newState = state
        newState.removeSearchKeyword = keyword
        
      return newState
    }
    
    private func errorMessageReduce(state: State, message: String) -> State {
        var newState = state
        newState.isErrorMessage = message
        return newState
    }
    
    private func searchTypeReduce(state: State, type: SearchState) -> State {
        var newState = state
        newState.type = type
        return newState
    }
    
    
    private func searchSelectedItemReduce(state: State, item: StoreDomainEntity) -> State {
        var newState = state
        newState.selectedItem = item
        return newState
    }
    
    private func restorePreviousSearchReduce(state: State, searchList: [String]) -> State {
        var newState = state
        
        let sectionItems = maker.makeSectionItems(keywords: searchList)
        
        newState.searchSection = [
            SearchSection(identity: .keyword, items: sectionItems)
        ]
        return newState
    }
}


// sections tech


// UseCase -> error messsage ? (base ? server error. data empty... -> .... algori -> errorMessage....

// Repository -> ....

// Repository -> StoreDomainEntity List

// 5 store -> 3
// 3 store -> 1
// ........... (... ...
// finda > .... >>. ... ....




// documents, design
// Domain -> ... ? (design)
// - properties....

// documents (algori)
// -> Domain -> ... -> Domain(3) ..
// (external data -> ... algori(document) -> domain) -> screen data
