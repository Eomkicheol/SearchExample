//
//  DetailViewController.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation
import UIKit

import ModuleComponents
import DetailRequirement

import ReactorKit
import Utils
import Components
import Common

import DomainEntity

public enum DetatilStackViewType {
    case appInfo
    case appShortVariety
    case release
    case content
}


public class DetailViewController: UIViewController, DetailControllerable, ReactorKit.View {
    
    // MARK: - View
    var content = ListView()
    
    // MARK: - Property
    var router: DetailRoutable?
    weak public var listener: DetailListener?
    
    private enum Const {
        static let spacing: CGFloat = 20
    }
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public typealias Reactor = DetailReactor
    
    // MARK: - Initializer
    
    // MARK: - Lifecycle
    public override func loadView() {
        self.view = content
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        setUp()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpAction()
    }
    
    private func setUpLayout() {
        self.view.backgroundColor = .white
    }
    
    private func setUpAction() {}
    
    public func bind(reactor: Reactor) {
        self.bindWillAppear(reactor: reactor)
        self.bindNavigationItems(reactor: reactor)
        self.bindAppInfoView(reactor: reactor)
        self.bindAppShortVarietyInfoView(reactor: reactor)
        self.bindNewFeaturesView(reactor: reactor)
        self.bindScreenshotsView(reactor: reactor)
        self.bindDescriptionView(reactor: reactor)
        self.bindNavigationStatus(reactor: reactor)
        self.bindDetailInfosView(reactor: reactor)
        self.bindScrollViewDidScroll(reactor: reactor)
    }
}

extension DetailViewController {
    private func bindWillAppear(reactor: Reactor) {
        self.rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationItems(reactor: Reactor) {
        reactor.state.map { $0.navigationTitle }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { vc, thumbnail in
                vc.configureThumbnailAppInfoNavigationItem(thumbnail)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationStatus(reactor: Reactor) {
        reactor.state
            .map { $0.navigationStatus }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { vc, status in
                vc.toggleNavigationBarVisibility(status: status)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindAppInfoView(reactor: Reactor) {
        
        reactor.state.map { $0.appInfo }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self, onNext: { vc, item in
                vc.content.attachViewToStack(attchViewType: .appInfo,
                                             item: item)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindAppShortVarietyInfoView(reactor: Reactor) {
        reactor.state.map { $0.appShortVarietyInfo}
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { vc, item in
                vc.content.attachViewToStack(attchViewType: .appShortVariety, item: item)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindScreenshotsView(reactor: Reactor) {
        reactor.state.map { $0.screenshotsInfo }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { vc, item in
                vc.content.createAndSetupCategoryAndScreenshotsViews(with: item)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNewFeaturesView(reactor: Reactor) {
        
        reactor.state.map { $0.newFeaturesInfo }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { vc, item in
                vc.content.attachViewToStack(attchViewType: .release, item: item)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindDescriptionView(reactor: Reactor) {
        
        reactor.state.map { $0.descriptionInfo}
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { vc, item in
                vc.content.attachViewToStack(attchViewType: .content, item: item)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindDetailInfosView(reactor: Reactor) {
        reactor.state.map { $0.detailInfo }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { vc, item in
                vc.content.createDetailInfoViews(with: item)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindScrollViewDidScroll(reactor: Reactor) {
        self.content.rx.didScroll
            .map { Reactor.Action.scrollViewOffset($0)}
            .bind(to: reactor.action)
            .disposed(by: self.content.disposeBag)
    }
}

extension DetailViewController {
    private func fadeInNavigationItems() {
        navigationItem.titleView?.isHidden = false
        navigationItem.rightBarButtonItem?.customView?.isHidden = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.navigationItem.titleView?.alpha = 1
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
        }
    }
    
    private func fadeOutNavigationItems() {
        navigationItem.titleView?.alpha = .zero
        navigationItem.titleView?.isHidden = true
        navigationItem.rightBarButtonItem?.customView?.alpha = .zero
        navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
    fileprivate func configureThumbnailAppInfoNavigationItem(_ thumbnail: String) {
        self.createAndHideNavigationTitleView(with: thumbnail)
        self.createAndAddTransparentDownloadButton()
    }
    
    private func toggleNavigationBarVisibility(status: Bool) {
        if status {
            self.fadeInNavigationItems()
        } else {
            self.fadeOutNavigationItems()
        }
    }
    
    private func createAndHideNavigationTitleView(with thumbnail: String) {
        let titleView = NavigationTitleView(frame: .zero, thumbnail: thumbnail)
        self.navigationItem.titleView = titleView
        self.navigationItem.titleView?.isHidden = true
    }
    
    private func createAndAddTransparentDownloadButton() {
        let downloadButton = DownloadButton(frame: .init(origin: .zero, size: .init(width: 60, height: 20)))
        downloadButton.setTitle("다운로드", for: .normal)
        let rightItem = UIBarButtonItem(customView: downloadButton)
        rightItem.customView?.alpha = .zero
        self.navigationItem.setRightBarButton(rightItem, animated: true)
    }
}

extension DetailViewController: AppInfoViewDelegate {
    public func didTapSharedButton() {
        guard let trackName = self.reactor?.currentState.itesm.trackName else { return }
        let items = [trackName]
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
}
