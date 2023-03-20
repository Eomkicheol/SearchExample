//
//  SearchResultCollectionViewCell.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import Then
import ReactorKit
import RxDataSources
import RxSwift
import RxCocoa
import Components
import ReusableKit
import ImageLoader
import DomainEntity

extension Reactive where Base: SearchResultCollectionViewCell {
    var didTap: ControlEvent<StoreDomainEntity> {
        let source = UITapGestureRecognizer().then {
            self.base.addGestureRecognizer($0)
            self.base.isUserInteractionEnabled = true
        }.rx.event.map { _  in
            return self.base.reactor?.currentState.items
        }.filterNil()
        return ControlEvent(events: source)
    }
}

public class SearchResultCollectionViewCell: UICollectionViewCell, ReactorKit.View  {
    
    public typealias Reactor = SearchResultCellReactor
    
    public typealias ImageSection = RxCollectionViewSectionedReloadDataSource<PreviewImageSection>
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var dataSource = self.createDataSource()
    
    let thumbnailImageView = RoundedImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.radiusRatio = 4.0
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 2
    }
    
    
    let appNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 1
    }
    
    let appDescriptionLabel = UILabel().then {
        $0.textColor = .systemGray4
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.numberOfLines = 1
    }
    
    let ratingStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 2
    }
    
    lazy var ratingView = RatingView().then {
        $0.tintColor = .systemGray2
        $0.totalStars = 5
        $0.starSize = 12
        $0.starMargin = 1
        $0.halfStarImage = UIImage(systemName: "star.leadinghalf.filled")
        $0.filledStarImage = UIImage(systemName: "star.fill")
        $0.emptyStarImage = UIImage(systemName: "star")
    }
    
    let userRatingCountLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.numberOfLines = 1
    }
    
    let downloadButton = RoundedButton().then {
        $0.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 246/255, alpha: 1.0)
        $0.topInset = 0
        $0.bottomInset = 0
        $0.radiusRatio = 13
        $0.rightInset = 15
        $0.leftInset = 15
        $0.setTitle("받기", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        $0.isOverrideIntrinsicContentSize = true
    }
    
    private enum Reusable {
        static let previewCell = ReusableCell<AppPreviewCollectionViewCell>()
    }
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
        }
    ).then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .white
        $0.register(Reusable.previewCell)
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
        
        
        [thumbnailImageView, stackView,
         downloadButton, collectionView].forEach {
            self.contentView.addSubview($0)
        }
        
        [appNameLabel, appDescriptionLabel, ratingStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [ratingView, userRatingCountLabel].forEach {
            ratingStackView.addArrangedSubview($0)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(15)
            $0.size.equalTo(48)
            
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(5)
            $0.centerY.equalTo(thumbnailImageView)
        }
        
        downloadButton.snp.makeConstraints {
            $0.centerY.equalTo(stackView)
            $0.trailing.equalToSuperview().offset(-15)
            $0.leading.greaterThanOrEqualTo(stackView.snp.trailing).offset(8)
        }
        
        ratingView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(12)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        ratingView.setupViews()
    }
    
    
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    public func bind(reactor: Reactor) {
        self.bindCollectionDelegate()
        self.bindMenuBarSection(reactor: reactor)
        self.bindCellItem(reactor: reactor)
    }
}

extension SearchResultCollectionViewCell {
    private func bindCollectionDelegate() {
        self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    private func bindMenuBarSection(reactor: Reactor) {
        reactor.state
            .map { $0.menuBarSection }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func bindCellItem(reactor: Reactor) {
        reactor.state
            .compactMap(\.items)
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { cell , result in
                let thumbnail = reactor.event.thumbnail60Image
                cell.appNameLabel.text = result.trackName
                cell.appDescriptionLabel.text = result.appDescription
                cell.ratingView.rating = result.averageUserRating
                cell.userRatingCountLabel.text = result.userRatingCount.convertToRatingFormatter()
                cell.thumbnailImageView.setImage(urlString: thumbnail)
            }
            .disposed(by: self.disposeBag)
    }
}

extension SearchResultCollectionViewCell {
    private func createDataSource() -> ImageSection {
        return .init(configureCell: { _, collectionView, indexPath, sectionItem -> UICollectionViewCell in
            switch sectionItem {
            case let .image(cellReactor):
                let cell = collectionView.dequeue(Reusable.previewCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
}
//
extension SearchResultCollectionViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 52) / 3
        let height = width * 16 / 8.7
        return .init(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

