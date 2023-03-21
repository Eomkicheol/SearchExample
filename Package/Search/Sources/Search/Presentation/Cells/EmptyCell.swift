//
//  EmptyCell.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import ReactorKit
import Then
import SnapKit
import RxSwift
import RxCocoa

public class EmptyCell: UICollectionViewCell, View {
    
    public typealias Reactor = EmptyCellReactor
    

    public var disposeBag = DisposeBag()
    
    
    let emptyTitle = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.numberOfLines = 1
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [emptyTitle].forEach {
            self.contentView.addSubview($0)
        }
        
        emptyTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    public func bind(reactor: EmptyCellReactor) {
        reactor.state
            .map { $0.items }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] name in
                guard let self = self else { return }
                self.emptyTitle.text = name
            })
            .disposed(by: self.disposeBag)
    }
}
