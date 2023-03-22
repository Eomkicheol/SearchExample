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

extension Reactive where Base: ListView {
    var didScroll: ControlEvent<CGFloat> {
        let source = self.base.scrollView.rx.didScroll
            .map { _ in self.base.scrollView.contentOffset.y }
            return ControlEvent(events: source)
    }
}

public class ListView: UIView, UIScrollViewDelegate {
    
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
    
    
}

// MARK: Func
extension ListView {}

