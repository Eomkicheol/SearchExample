//
//  AppInfoView.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import UIKit

import Then
import SnapKit
import ImageLoader
import DomainEntity


public protocol AppInfoViewDelegate: AnyObject {
    func didTapSharedButton()
}

public class AppInfoView: UIView {
    
    public weak var delegate: AppInfoViewDelegate?
    
    var thumbnailImageView = RoundedImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.radiusRatio = 15
        $0.borderColor = .systemGray6
    }
    
    var statckView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    var appNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.numberOfLines = 2
    }
    
    var appDescriptionLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 1
    }
    
    let downloadButton = DownloadButton(frame: .zero)
    
    lazy var shareButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        $0.addTarget(self, action: #selector(didTapSharedButton(_:)), for: .touchUpInside)
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(with item: StoreDomainEntity) {
        appNameLabel.text = item.trackName
        appDescriptionLabel.text = item.appDescription
        thumbnailImageView.setImage(urlString: item.thumbnail60Image)
        
//        if let url = URL(string: item.thumbnamil100ImageURL) {
//
//            //kf.setImage(with: url)
//        }
    }
    
    func setupViews() {
        [thumbnailImageView, statckView, downloadButton, shareButton].forEach {
            self.addSubview($0)
        }
        
        [appNameLabel, appDescriptionLabel].forEach {
            statckView.addArrangedSubview($0)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.width.equalTo(110)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        statckView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        downloadButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(statckView.snp.bottom).offset(5)
            $0.leading.equalTo(statckView)
            $0.height.equalTo(25)
            $0.width.equalTo(60)
            $0.bottom.equalTo(thumbnailImageView)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(thumbnailImageView)
            $0.size.equalTo(24)
        }
    }
    
    @objc private func didTapSharedButton(_ sender: UIButton) {
        delegate?.didTapSharedButton()
    }
}

