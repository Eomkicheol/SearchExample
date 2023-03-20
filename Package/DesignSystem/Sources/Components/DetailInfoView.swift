//
//  DetailInfoView.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import UIKit

import Then
import SnapKit

import DomainEntity

public class DetailInfoView: UIView {
    
    var statview = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    lazy var titleView = UIView().then {
        $0.backgroundColor = .white
        $0.addGestureRecognizer(self.moreTapGesture)
    }
    
    var titleLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 1
    }
    
    var subTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 1
    }
    
    var appDescriptionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.numberOfLines = 0
    }
    
    var moreImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    var subInfoStatview = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 3
    }
    
    lazy var moreTapGesture = UITapGestureRecognizer().then {
        $0.addTarget(self, action: #selector(didTapTitleView))
    }
    
    weak var appDescriptionLabelHeightConstraint: Constraint?
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupViews()
    }
    
    public func setup(with item: AppDetailInfoItem) {
//        AppDetailInfoItem/
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
        moreImageView.isHidden = item.description.isNil
        moreTapGesture.isEnabled = item.description.isNotNil
        appDescriptionLabel.isHidden = true
        
        if let description = item.description {
            let attributedString = NSMutableAttributedString(string: description)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
            appDescriptionLabel.attributedText = attributedString
        }
    }
    
    public func setupViews() {
        [statview].forEach {
            self.addSubview($0)
        }
        
        [titleView, appDescriptionLabel].forEach {
            statview.addArrangedSubview($0)
        }
        
        [titleLabel, subInfoStatview].forEach {
            titleView.addSubview($0)
        }
        
        [subTitleLabel, moreImageView].forEach {
            subInfoStatview.addArrangedSubview($0)
        }
        
        statview.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        subInfoStatview.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        appDescriptionLabel.snp.makeConstraints {
            self.appDescriptionLabelHeightConstraint = $0.height.greaterThanOrEqualTo(0).constraint
        }
        
    }
    
    @objc private func didTapTitleView(_ sender: UITapGestureRecognizer) {
        appDescriptionLabel.isHidden = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            self.subTitleLabel.alpha = .zero
            self.moreImageView.alpha = .zero
            self.appDescriptionLabelHeightConstraint?.update(offset: self.appDescriptionLabel.intrinsicContentSize.height + 20) 
        }, completion: { position in
            if case .end = position {
                self.subTitleLabel.isHidden = true
                self.moreImageView.isHidden = true
            }
        })
    }
}
