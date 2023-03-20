//
//  RoundedImageView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

public class RoundedImageView: UIImageView {
    
    public var radiusRatio: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = radiusRatio
        }
    }
    
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    public var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public override init(image: UIImage!) {
        super.init(image: image)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.masksToBounds = true
    }
}

