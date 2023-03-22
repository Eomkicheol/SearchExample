//
//  ListView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//


import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift
import ReusableKit
import RxDataSources

import DomainEntity

public protocol ListViewDelegate: NSObject {
    func selectedItem(with item: StoreDomainEntity)
    func selectedKeyword(with keyword: String)
}

public class ListView: UIView, UIScrollViewDelegate {
    
    // MARK: - View
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }).then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
        
        $0.register(Reusable.keywordCell)
        $0.register(Reusable.emptyCell)
        $0.register(Reusable.searchResultCell)
    }
    
    
    // MARK: - Property
    typealias FetchSearchKeywordSection = RxCollectionViewSectionedReloadDataSource<SearchSection>
    
    private lazy var dataSource = self.createDataSource()
    
    public var disposeBag = DisposeBag()
    
    private let sectionsRelay: PublishRelay<[SearchSection]> = .init()
    
    weak var delegate: ListViewDelegate?
    
    private enum Reusable {
        static let keywordCell = ReusableCell<SearchKeywordCell>()
        static let emptyCell = ReusableCell<EmptyCell>()
        static let searchResultCell = ReusableCell<SearchResultCollectionViewCell>()
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
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
        
        [collectionView].forEach {
            self.addSubview($0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setUpState() {
        self.backgroundColor = .white
    }
    
    private func setUpAction() {
        self.bindDataSource()
        self.bindDelegate()
    }
}

// MARK: Func
extension ListView {
    private func bindDataSource() {
        self.sectionsRelay.distinctUntilChanged()
            .bind(to: collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    //
    private func bindDelegate() {
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    public func updateUI(sections: [SearchSection]) {
        self.sectionsRelay.accept(sections)
    }
    
}

extension ListView {
    private func createDataSource() -> FetchSearchKeywordSection {
        return .init(configureCell: { _, collectionView, indexPath, sectionItem -> UICollectionViewCell in
            switch sectionItem {
            case .keyword(let cellReactor):
                
                let cell = collectionView.dequeue(Reusable.keywordCell, for: indexPath)
                
                if cell.reactor !== cellReactor {
                    cell.reactor = cellReactor
                    cell.rx.didTap
                        .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                        .asDriver(onErrorJustReturn: "")
                        .drive(with: self, onNext: { cell, keyword in
                            cell.delegate?.selectedKeyword(with: keyword)
                        })
                        .disposed(by: cell.disposeBag)
                }
                return cell
                
            case let .empty(cellReactor):
                let cell = collectionView.dequeue(Reusable.emptyCell, for: indexPath)
                
                cell.reactor = cellReactor
                
                return cell
                
            case let .result(cellReactor):
                let cell = collectionView.dequeue(Reusable.searchResultCell, for: indexPath)
                
                if cell.reactor !== cellReactor {
                    cell.reactor = cellReactor
                    cell.rx.didTap
                        .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                        .asDriver(onErrorJustReturn: .init(item: .init()))
                        .drive(with: self, onNext: { cell, item in
                            cell.delegate?.selectedItem(with: item)
                        })
                        .disposed(by: cell.disposeBag)
                }
                
                return cell
            }
        })
    }
}

extension ListView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.dataSource[indexPath.section]
        switch section.identity {
        case .keyword:
            return CGSize(width: collectionView.bounds.width, height: 50.0)
            
        case .empty:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            
        case .result:
            let width = (UIScreen.main.bounds.size.width - 52) / 3
            let collectionViewHeight = width * 16 / 9
            
            return CGSize(width: collectionView.bounds.width, height: collectionViewHeight + 96)
        }
    }
}
