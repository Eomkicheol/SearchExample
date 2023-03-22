//
//  ListView.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift
import ReusableKit
import RxDataSources
import DomainEntity
import Components

extension Reactive where Base: ListView {
    var didScroll: ControlEvent<CGFloat> {
        let source = self.base.scrollView.rx.didScroll
            .map { _ in self.base.scrollView.contentOffset.y }
            return ControlEvent(events: source)
    }
}

public class ListView: UIView {
    
    // MARK: - View
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bouncesZoom = false
        $0.bounces = false
        $0.backgroundColor = .white
    }
    
    public var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 5
        $0.backgroundColor = .white
    }
    
    // MARK: - Property
    private enum Const {
        static let spacing: CGFloat = 20
    }
    
    public var disposeBag = DisposeBag()
    
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        [scrollView].forEach {
            self.addSubview($0)
        }
        
        [stackView].forEach {
            scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.frameLayoutGuide)
            $0.height.equalTo(self.scrollView.frameLayoutGuide).priority(1)
        }
    }
    
    
    private func setUpState() {
        self.backgroundColor = .white
    }
    
    private func setUpAction() {}
    
    public func attachViewToStack(attchViewType: DetatilStackViewType, item: StoreDomainEntity ) {
        switch attchViewType {
        case .appInfo:
            self.attachApppInfoView(with: item)
        case .appShortVariety:
            self.createAndSetupAppShortVarietyInfoView(with: item)
        case .release:
            self.createAndSetupReleaseInfoAndContentViews(with: item)
        case .content:
            self.configureContentAndDeveloperViews(with: item)
        }
    }
}

// MARK: Func
extension ListView {
    private func attachApppInfoView(with item: StoreDomainEntity) {
        let infoView = AppInfoView()
        infoView.delegate = self
        infoView.setup(with: item)
        let lineView = DividerView(frame: .zero, spacing: Const.spacing)
        stackView.addArrangedSubviews(infoView, lineView)
    }
    
    private func createAndSetupAppShortVarietyInfoView(with item: StoreDomainEntity) {
        let infoView = AppShortVarietyInfoView(frame: .zero)
        let lineView = DividerView(frame: .zero, spacing: Const.spacing)
        infoView.setup(with: item)
        stackView.addArrangedSubviews(infoView, lineView)
    }
    
    public func createAndSetupCategoryAndScreenshotsViews(with item: [String]) {
        let titleView = CategoryView()
        titleView.setup(title: "미리보기", subTitle: nil)
        let lineView = DividerView(frame: .zero, spacing: 20)
        let screensView = ScreenshotsView()
        screensView.setup(with: item)
        stackView.addArrangedSubviews(titleView, screensView, lineView)
    }
    
    private func createAndSetupReleaseInfoAndContentViews(with item: StoreDomainEntity) {
        let titleView = CategoryView()
        titleView.setup(title: "새로운 기능", subTitle: "버전 기록")
        let releaseInfoView = ReleaseInfoView()
        releaseInfoView.setup(version: item.version, date: item.releaseDate)
        let contentView = ContentExpandableView()
        let lineView = DividerView(frame: .zero, spacing: Const.spacing)
        contentView.setup(content: item.releaseNotes)
        stackView.addArrangedSubviews(titleView, releaseInfoView, contentView, lineView)
    }
    
    private func configureContentAndDeveloperViews(with item: StoreDomainEntity) {
        let contentView = ContentExpandableView()
        let developerView = DeveloperInfoView()
        let lineView = DividerView(frame: .zero, spacing: Const.spacing)
        contentView.setup(content: item.description)
        developerView.setup(with: item.sellerName)
        stackView.addArrangedSubviews(contentView, developerView, lineView)
    }
    
    public func createDetailInfoViews(with items: [AppDetailInfoItem]) {
        let titleView = CategoryView()
        titleView.setup(title: "정보", subTitle: nil)
        stackView.addArrangedSubview(titleView)

        for item in items {
            let detailInfoView = DetailInfoView()
            detailInfoView.setup(with: item)
            let lineView = DividerView(frame: .zero, spacing: Const.spacing)
            stackView.addArrangedSubview(detailInfoView)
            stackView.addArrangedSubview(lineView)
        }
    }
}


extension ListView: AppInfoViewDelegate {
    public func didTapSharedButton() {
        
    }
}

