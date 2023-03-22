//
//  DeveloperInfoView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import SnapKit
import Then

public class DeveloperInfoView: UIView {
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 1
    }
    
    let titleLabel = UILabel().then {
        $0.text = "개발자"
        $0.textColor = .systemGray2
        
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.numberOfLines = 1
    }
    
    let sellerNameLabel = UILabel().then {
        $0.textColor = .link
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.numberOfLines = 1
    }
    
    let moreButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .systemGray2
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public func setup(with sellerName: String) {
        self.sellerNameLabel.text = sellerName
    }
    
    public func setupViews() {
        backgroundColor = .white
        
        [stackView, moreButton].forEach {
            self.addSubview($0)
        }
        
        [sellerNameLabel, titleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(stackView)
            $0.size.equalTo(30)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
}

