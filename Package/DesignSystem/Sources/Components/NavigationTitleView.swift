//
//  NavigationTitleView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import Foundation

import UIKit
import SnapKit
import Common
import ImageLoader

public class NavigationTitleView: UIView {
    
    private let imageView: RoundedImageView = RoundedImageView(frame: .zero)
    
    public init(frame: CGRect, thumbnail: String) {
        super.init(frame: frame)
        setupViews(with: thumbnail)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("The \(Self.className) has not been implemented")
    }
    
    private func setupViews(with thumbnail: String) {
                
        imageView.borderColor = .systemGray6
        imageView.radiusRatio = 4
        imageView.setImage(urlString: thumbnail)
        
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(26)
            $0.centerY.centerX.equalToSuperview()
        }
    }
}

