//
//  AppPreviewCollectionViewCell.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import Components
import ReactorKit
import ImageLoader

class AppPreviewCollectionViewCell: UICollectionViewCell, ReactorKit.View {
    
    typealias Reactor = AppPreviewCellReactor
    
    private enum Constants {}
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let imageView = RoundedImageView(frame: .zero).then {
        $0.radiusRatio = 15
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.borderColor = .systemGray6
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [imageView].forEach {
            self.contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func bind(reactor: Reactor) {
        reactor.state
            .map { $0.items }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { cell, name in
                cell.imageView.setImage(urlString: name)
            })
            .disposed(by: self.disposeBag)
    }
}
