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


public protocol DetailControllerable: UIViewControllable {
    var listener: DetailListener? { get set }
    var disposeBag: DisposeBag { get }
}

public class DetailViewController: UIViewController, DetailControllerable, ReactorKit.View {
    
    // MARK: - View
    lazy var content = ListView().then {
        $0.delegate = self
    }
    
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
        self.bindScreenshotsView(reactor: reactor)
        self.bindNewFeaturesView(reactor: reactor)
        self.bindDescriptionView(reactor: reactor)
        self.bindNavigationStatus(reactor: reactor)
        self.bindDetailInfosView(reactor: reactor)
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
        reactor.pulse(\.$navigationTitle)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { vc, thumbnail in
                let titleView = NavigationTitleView(frame: .zero, thumbnail: thumbnail)
                vc.navigationItem.titleView = titleView
                vc.navigationItem.titleView?.isHidden = true
                let downloadButton = DownloadButton(frame: .init(origin: .zero, size: .init(width: 60, height: 20)))
                downloadButton.setTitle("다운로드", for: .normal)
                let rightItem = UIBarButtonItem(customView: downloadButton)
                rightItem.customView?.alpha = .zero
                vc.navigationItem.setRightBarButton(rightItem, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationStatus(reactor: Reactor) {
        
        reactor.state
            .map { $0.navigationStatus }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] status in
                guard let self = self else { return }
                if status {
                    self.fadeInNavigationItems()
                } else {
                    self.fadeOutNavigationItems()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindAppInfoView(reactor: Reactor) {
        
        reactor.pulse(\.$appInfo)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self, onNext: { vc, item in
                let infoView = AppInfoView()
                infoView.delegate = self
                infoView.setup(with: item)
                let lineView = DividerView(frame: .zero, spacing: Const.spacing)
                vc.content.stackView.addArrangedSubviews(infoView, lineView)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindAppShortVarietyInfoView(reactor: Reactor) {
        reactor.pulse(\.$appShortVarietyInfo)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { vc, item in
                let infoView = AppShortVarietyInfoView(frame: .zero)
                let lineView = DividerView(frame: .zero, spacing: Const.spacing)
                infoView.setup(with: item)
                
                vc.content.stackView.addArrangedSubviews(infoView, lineView)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindScreenshotsView(reactor: Reactor) {
        reactor.pulse(\.$screenshotsInfo)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { vc, item in
                let titleView = CategoryView()
                titleView.setup(title: "미리보기", subTitle: nil)
                let lineView = DividerView(frame: .zero, spacing: 20)
                let screensView = ScreenshotsView()
                screensView.setup(with: item)
                
                vc.content.stackView.addArrangedSubviews(titleView, screensView, lineView)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNewFeaturesView(reactor: Reactor) {
        
        reactor.pulse(\.$newFeaturesInfo)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { vc, item in
                let titleView = CategoryView()
                titleView.setup(title: "새로운 기능", subTitle: "버전 기록")
                let releaseInfoView = ReleaseInfoView()
                releaseInfoView.setup(version: item.version, date: item.releaseDate)
                let contentView = ContentExpandableView()
                let lineView = DividerView(frame: .zero, spacing: Const.spacing)
                contentView.setup(content: item.releaseNotes)
                vc.content.stackView.addArrangedSubviews(titleView, releaseInfoView, contentView, lineView)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindDescriptionView(reactor: Reactor) {
        
        reactor.pulse(\.$descriptionInfo)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { vc, item in
                let contentView = ContentExpandableView()
                let developerView = DeveloperInfoView()
                let lineView = DividerView(frame: .zero, spacing: Const.spacing)
                contentView.setup(content: item.description)
                developerView.setup(with: item.sellerName)
                vc.content.stackView.addArrangedSubviews(contentView, developerView, lineView)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindDetailInfosView(reactor: Reactor) {
        reactor.pulse(\.$detailInfo)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { vc, item in
                let titleView = CategoryView()
                titleView.setup(title: "정보", subTitle: nil)
                vc.content.stackView.addArrangedSubviews(titleView)
                vc.makeDetailInfoView(item)
            }
            .disposed(by: self.disposeBag)
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
    
    private func makeDetailInfoView(_ temp: [AppDetailInfoItem]) {
        for item in temp {
            let detailInfoView = DetailInfoView()
            detailInfoView.setup(with: item)
            let lineView = DividerView(frame: .zero, spacing: Const.spacing)
            self.content.stackView.addArrangedSubviews(detailInfoView, lineView)
        }
    }
}

extension DetailViewController: ListViewDelegate {
    public func contentOffset(with offset: CGFloat) {
        self.reactor?.action.onNext(Reactor.Action.scrollViewOffset(offset))
    }
}

extension DetailViewController: AppInfoViewDelegate {
    public func didTapSharedButton() {
        let trackName = self.reactor?.currentState.itesm?.trackName ?? ""
        let items: [Any] = [trackName]
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
}
