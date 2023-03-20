//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

public class CategoryView: UIView {
    
    var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    var subTitleLabel = UILabel().then {
        $0.text = "서브 제목"
        $0.textColor = .systemBlue
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public func setup(title: String, subTitle: String?) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        [titleLabel, subTitleLabel].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.greaterThanOrEqualTo(subTitleLabel.snp.leading).offset(5)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

