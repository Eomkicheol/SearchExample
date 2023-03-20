//
//  ScreenshotsView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import Then
import SnapKit

import ReusableKit

public class ScreenshotsView: UIView {
    
    private enum Reusable {
        static let previewCell = ReusableCell<PreviewCollectionViewCell>()
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
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = true
        
        $0.register(Reusable.previewCell)
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    let phoneImageView = UIImageView(image: UIImage(systemName: "iphone")?.withRenderingMode(.automatic)).then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.text = "iPhone"
        $0.textColor = .systemGray2
        $0.font = UIFont.boldSystemFont(ofSize: 13)
    }
    
    private var urls: [String?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private enum Const {
        static let itemSize: CGSize = CGSize(width: 220, height: 450)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    // MARK: - Setup
    
    public func setup(with urls: [String]) {
        self.urls = urls
    }
}

extension ScreenshotsView {
    
    private func setupViews() {
        backgroundColor = .white
        
        [collectionView, stackView].forEach {
            self.addSubview($0)
        }
        
        [phoneImageView, titleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Const.itemSize)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}

extension ScreenshotsView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Const.itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(Reusable.previewCell, for: indexPath)
        cell.setup(with: urls[safe: indexPath.row]?.flatMap { $0 } ?? "")
        return cell
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = Const.itemSize.width + layout.minimumLineSpacing
        let estimatedIndex = scrollView.contentOffset.x / cellWidth
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidth, y: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}


