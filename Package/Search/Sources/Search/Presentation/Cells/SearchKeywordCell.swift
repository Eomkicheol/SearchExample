//
//  SearchKeywordCell.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import Then
import SnapKit
import RxOptional


extension Reactive where Base: SearchKeywordCell {
    
    var didTap: ControlEvent<String> {
        let source = UITapGestureRecognizer().then {
            self.base.addGestureRecognizer($0)
            self.base.isUserInteractionEnabled = true
        }.rx.event.map { _ in
            return self.base.reactor?.currentState.items
        }.filterNil()
        return ControlEvent(events: source)
    }
}

public class SearchKeywordCell: UICollectionViewCell, View {
    
    public typealias Reactor = SearchKeywordCellReactor
    
    let magnifyingGlassImageView = UIImageView(image: UIImage(systemName: "magnifyingglass")).then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    let searchTitle = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.numberOfLines = 1
    }
    
    public var disposeBag = DisposeBag()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.backgroundColor = .white
        
        [magnifyingGlassImageView, searchTitle].forEach {
            self.contentView.addSubview($0)
        }
        
        magnifyingGlassImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.size.equalTo(20)
            $0.centerY.equalTo(searchTitle)
        }
        
        searchTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(magnifyingGlassImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    public func bind(reactor: SearchKeywordCellReactor) {
        reactor.state
            .map { $0.items }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { cell, name in
                cell.searchTitle.text = name
            })
            .disposed(by: self.disposeBag)
    }
}
