//
//  AppShortVarietyInfoView.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import UIKit

import Then
import SnapKit

import DomainEntity

public class AppShortVarietyInfoView: UIView {
    
    var scrollView = UIScrollView().then {
        $0.bouncesZoom = false
        $0.showsVerticalScrollIndicator = false
    }
    
    var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    private var item: StoreDomainEntity?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [scrollView].forEach {
            self.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        [stackView].forEach {
            scrollView.addSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.height.equalTo(self.scrollView.frameLayoutGuide).priority(1)
        }

    }
    
    public func setup(with item: StoreDomainEntity) {

        
        item.shortVerietyInfo.enumerated().forEach {
            let stackView = createStackView()
            let lineView = VerticalDividerView(frame: .zero, spacing: 15, height: 60)
            let labels = createLabels()
            labels.top.text = $1.topDescription
            
            if $1.type == .review {
                labels.mid.text = $1.midDescription
                let ratingView = createRatingView($1.midDescription)
                stackView.addArrangedSubviews(labels.top, labels.mid, ratingView)
            } else if $1.type == .seller {
                let developerImageView = createSellerImageView()
                labels.bottom.text = $1.bottomDescription
                stackView.addArrangedSubviews(labels.top, developerImageView, labels.bottom)
            } else {
                labels.mid.text = $1.midDescription
                labels.bottom.text = $1.bottomDescription
                stackView.addArrangedSubviews(labels.top, labels.mid, labels.bottom)
            }
            
            let isLast: Bool = $0 == (item.infoItems.count - 1)
            if isLast {
                self.stackView.addArrangedSubviews(stackView)
            } else {
                self.stackView.addArrangedSubviews(stackView, lineView)
            }
            
            let width = max(labels.top.intrinsicContentSize.width, labels.mid.intrinsicContentSize.width, labels.bottom.intrinsicContentSize.width) + 40.0
            stackView.snp.makeConstraints {
                $0.height.equalTo(80)
                $0.width.equalTo(width)
            }
        }
    }
}


extension AppShortVarietyInfoView {
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }
    
    private func createLabels() -> (top: UILabel, mid: UILabel, bottom: UILabel) {
        let topLabel = UILabel()
        topLabel.textColor = .systemGray2
        topLabel.font = UIFont.systemFont(ofSize: 11)
        let midLabel = UILabel()
        midLabel.textColor = .systemGray
        midLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let bottomLabel = UILabel()
        bottomLabel.textColor = .systemGray
        bottomLabel.font = UIFont.systemFont(ofSize: 11)
        return (topLabel, midLabel, bottomLabel)
    }
    
    private func createRatingView(_ ratingText: String) -> UIView {
        let containerView = UIView()
        let ratingView = RatingView()
        ratingView.tintColor = .systemGray3
        ratingView.backgroundColor = .clear
        ratingView.starSize = 12
        ratingView.starMargin = 1
        ratingView.setupViews()
        ratingView.rating = Float(ratingText) ?? 0
        containerView.addSubview(ratingView)
        containerView.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        ratingView.snp.makeConstraints {
            $0.top.equalTo(13)
            $0.leading.equalTo(10)
        }
        return containerView
    }
    
    private func createSellerImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.square")
        imageView.snp.makeConstraints {
            $0.width.equalTo(30)

        }
        imageView.tintColor = .systemGray
        return imageView
    }
}
