//
//  ContentExpandableView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import SnapKit
import Then


public class ContentExpandableView: UIView {
    
    weak var contentLabelHeightConstraint: Constraint?
    
    var contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .left
    }
    
    lazy var moreButton = UIButton().then {
        $0.setTitle("더 보기", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        $0.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public func setup(content: String) {
        let attributedString = NSMutableAttributedString(string: content)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        contentLabel.attributedText = attributedString
        guard let defaultHeight = self.contentLabelHeightConstraint?.layoutConstraints.first?.constant else { return }
        if defaultHeight > contentLabel.intrinsicContentSize.height {
            moreButton.isHidden = true
        }
    }
    
    private func setupViews() {
        [contentLabel, moreButton].forEach {
            self.addSubview($0)
        }
        
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-15)
            self.contentLabelHeightConstraint = $0.height.lessThanOrEqualTo(60).constraint
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(contentLabel.snp.bottom).offset(13)
            $0.width.equalTo(40)
            $0.height.equalTo(30)
        }
        
        backgroundColor = .white
    }
    
    @objc private func didTapMoreButton(_ sender: UIButton) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.moreButton.isHidden = true
                self.contentLabelHeightConstraint?.update(offset: self.contentLabel.intrinsicContentSize.height)
                self.layoutIfNeeded()
            })
        }
    }
