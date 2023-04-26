//
//  DetailReactor.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import UIKit

import ReactorKit
import RxSwift

import DomainEntity


final class DetailReactor: Reactor {
    
    private enum Constants {}
    
    
    public var initialState: State = State()
    
    
    deinit {
        print(self)
    }
    
    init(item: StoreDomainEntity) {
        defer { _ = self.state }
        self.initialState = State(itesm: item)
    }
    
    public enum Action {
        case viewWillAppear
        case scrollViewOffset(CGFloat)
    }
    
    public struct State {
        var itesm: StoreDomainEntity = .init(item: .init())
        var navigationTitle: String = ""
        var appInfo: StoreDomainEntity = .init(item: .init())
        var appShortVarietyInfo: StoreDomainEntity = .init(item: .init())
        var screenshotsInfo: [String] = []
        var newFeaturesInfo: StoreDomainEntity = .init(item: .init())
        var descriptionInfo: StoreDomainEntity = .init(item: .init())
        var detailInfo: [AppDetailInfoItem] = .init()
        var navigationStatus: Bool = false
    }
    
    public enum Mutation {
        case setNavigationTitle(String)
        case setAppInfo(StoreDomainEntity)
        case setAppShortVarietyInfo(StoreDomainEntity)
        case setScreenshotsInfo([String])
        case setNewFeaturesInfo(StoreDomainEntity)
        case setDescriptionInfo(StoreDomainEntity)
        case setDetailInfo([AppDetailInfoItem])
        case setNavigationStatus(Bool)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return self.setNavigationTitleMutation()
            
        case let .scrollViewOffset(offset):
            return self.setChangedScrollViewOffsetMutation(wiht: offset)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setNavigationTitle(value):
            newState = self.setNavigationTitleReduce(state: state, title: value)
        case let .setNavigationStatus(value):
            newState = self.setNavigationStatusReduce(state: state, status: value)
        case let .setAppInfo(storeModel):
            newState = self.setAppInfoReduce(state: state, item: storeModel)
        case let .setAppShortVarietyInfo(storeModel):
            newState = self.setAppShortVarietyInfoReduce(state: state, item: storeModel)
        case let .setScreenshotsInfo(screenShots):
            newState = self.setScreenshotsInfoReduce(state: state, screens: screenShots)
        case let .setNewFeaturesInfo(storeModel):
            newState = self.setNewFeaturesInfoReduce(state: state, item: storeModel)
        case let .setDescriptionInfo(storeModel):
            newState = self.setDescriptionInfoReduce(state: state, item: storeModel)
        case let .setDetailInfo(detailInfoItem):
            newState = self.setDetailInfoReduce(state: state, item: detailInfoItem)
        }
        
        return newState
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(mutation, self.setAppInfoMutation(),
                                self.setAppShortVarietyInfoMutation(),
                                self.setNewFeaturesInfoMutation(),
                                self.setScreenshotsInfoMutation(),
                                self.setDetailInfoMutation(),
                                self.setDescriptionInfoMutation())
    }
}

// MARK: Mutation
extension DetailReactor {
    
    private func setNavigationTitleMutation() -> Observable<Mutation> {
        let item = self.currentState.itesm
        return Observable.just(Mutation.setNavigationTitle(item.thumbnail60Image))
    }
    
    private func setChangedScrollViewOffsetMutation(wiht offset: CGFloat) -> Observable<Mutation> {
        var status: Bool = false
        
        if offset >= 110 {
            status = true
        } else {
            status = false
        }
        
        return Observable.just(Mutation.setNavigationStatus(status))
    }
    
    private func setAppInfoMutation() -> Observable<Mutation> {
        let item = self.currentState.itesm
        return Observable.just(Mutation.setAppInfo(item))
    }
    
    private func setAppShortVarietyInfoMutation() -> Observable<Mutation> {
        let item = self.currentState.itesm
        return Observable.just(Mutation.setAppShortVarietyInfo(item))
    }
    
    private func setScreenshotsInfoMutation() -> Observable<Mutation> {
        guard let item = self.currentState.itesm.screenshotName else { return Observable.empty() }
        
        if item.isEmpty {
            return Observable.empty()
        }
        return Observable.just(Mutation.setScreenshotsInfo(item))
    }
    
    private func setNewFeaturesInfoMutation() -> Observable<Mutation> {
        let item = self.currentState.itesm
        
        if item.releaseNotes.isEmpty {
            return Observable.empty()
        }
        return Observable.just(Mutation.setNewFeaturesInfo(item))
    }
    
    private func setDescriptionInfoMutation() -> Observable<Mutation> {
        let item = self.currentState.itesm
        return Observable.just(Mutation.setDescriptionInfo(item))
    }
    
    private func setDetailInfoMutation() -> Observable<Mutation> {
        let item = self.currentState.itesm
        return Observable.just(Mutation.setDetailInfo(item.infoItems))
    }
}


extension DetailReactor {
    private func setNavigationTitleReduce(state: State, title: String) -> State {
        var newState = state
        newState.navigationTitle = title
        return newState
    }
    
    private func setNavigationStatusReduce(state: State, status: Bool) -> State {
        var newState = state
        newState.navigationStatus = status
        return newState
    }
    
    private func setAppInfoReduce(state: State, item: StoreDomainEntity) -> State {
        var newState = state
        newState.appInfo = item
        return newState
    }
    
    private func setAppShortVarietyInfoReduce(state: State, item: StoreDomainEntity) -> State {
        var newState = state
        newState.appShortVarietyInfo = item
        return newState
    }
    
    private func setScreenshotsInfoReduce(state: State, screens: [String]) -> State {
        var newState = state
        newState.screenshotsInfo = screens
        return newState
    }
    
    private func setNewFeaturesInfoReduce(state: State, item: StoreDomainEntity) -> State {
        var newState = state
        newState.newFeaturesInfo = item
        return newState
    }
    
    private func setDescriptionInfoReduce(state: State, item: StoreDomainEntity) -> State {
        var newState = state
        newState.descriptionInfo = item
        return newState
    }
    
    private func setDetailInfoReduce(state: State, item: [AppDetailInfoItem]) -> State {
        var newState = state
        newState.detailInfo = item
        return newState
    }
}
