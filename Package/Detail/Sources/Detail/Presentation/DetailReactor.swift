//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import UIKit

import ReactorKit
import RxSwift

import DomainEntity


public class DetailReactor: Reactor {
    
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
        @Pulse var itesm: StoreDomainEntity?
        @Pulse var navigationTitle: String?
        @Pulse var appInfo: StoreDomainEntity?
        @Pulse var appShortVarietyInfo: StoreDomainEntity?
        @Pulse var screenshotsInfo: [String]?
        @Pulse var newFeaturesInfo: StoreDomainEntity?
        @Pulse var descriptionInfo: StoreDomainEntity?
        @Pulse var detailInfo: [AppDetailInfoItem]?
        
        var navigationStatus: Bool = false
    }
    
    public enum Mutation {
        case setNavigationTitle(String)
        case setAppInfo(StoreDomainEntity)
        case setAppShortVarietyInfo(StoreDomainEntity)
        case setScreenshotsInfo([String]?)
        case setNewFeaturesInfo(StoreDomainEntity)
        case setDescriptionInfo(StoreDomainEntity)
        case setDetailInfo([AppDetailInfoItem])
        case setNavigationStatus(Bool)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .viewWillAppear:
                let item = self.currentState.itesm
                return Observable.just(Mutation.setNavigationTitle(item?.thumbnail60Image ?? ""))
    
            case let .scrollViewOffset(offset):
                var status: Bool = false
                
                if offset >= 110 {
                    status = true
                } else {
                    status = false
                }
                
                return Observable.just(Mutation.setNavigationStatus(status))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            case let .setNavigationTitle(value):
                newState.navigationTitle = value
                
            case let .setNavigationStatus(value):
                newState.navigationStatus = value
            case let .setAppInfo(viewModelItem):
                newState.appInfo = viewModelItem
            case let .setAppShortVarietyInfo(dto):
                newState.appShortVarietyInfo = dto
            case let .setScreenshotsInfo(screenShots):
                newState.screenshotsInfo = screenShots
            case let .setNewFeaturesInfo(viewModelItem):
                newState.newFeaturesInfo = viewModelItem
            case let .setDescriptionInfo(viewModelItem):
                newState.descriptionInfo = viewModelItem
            case let .setDetailInfo(item):
                newState.detailInfo = item
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


extension DetailReactor {
    private func setAppInfoMutation() -> Observable<Mutation> {
        guard let item = self.currentState.itesm else { return Observable.empty() }
        return Observable.just(Mutation.setAppInfo(item))
    }
    
    private func setAppShortVarietyInfoMutation() -> Observable<Mutation> {
        guard let item = self.currentState.itesm else { return Observable.empty() }
        return Observable.just(Mutation.setAppShortVarietyInfo(item))
    }
    
    private func setScreenshotsInfoMutation() -> Observable<Mutation> {
        guard let item = self.currentState.itesm?.screenshotName else { return Observable.empty() }
        
        if item.isEmpty {
            return Observable.empty()
        }
        return Observable.just(Mutation.setScreenshotsInfo(item))
    }
    
    
    private func setNewFeaturesInfoMutation() -> Observable<Mutation> {
        guard let item = self.currentState.itesm else { return Observable.empty() }
        
        if item.releaseNotes.isEmpty {
            return Observable.empty()
        }
        return Observable.just(Mutation.setNewFeaturesInfo(item))
    }
    
    private func setDescriptionInfoMutation() -> Observable<Mutation> {
        guard let item = self.currentState.itesm else { return Observable.empty() }
        return Observable.just(Mutation.setDescriptionInfo(item))
    }
    
    private func setDetailInfoMutation() -> Observable<Mutation> {
        guard let item = self.currentState.itesm else { return Observable.empty() }
        return Observable.just(Mutation.setDetailInfo(item.infoItems))
    }
}
