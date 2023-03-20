//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

public class RoundedButton: UIButton {
    
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
    
    public var topInset: CGFloat = 5.0
    
    public var bottomInset: CGFloat = 5.0
    
    public var leftInset: CGFloat = 5.0
    
    public var rightInset: CGFloat = 5.0
    
    public var isOverrideIntrinsicContentSize: Bool = true
    
        
    public override var intrinsicContentSize: CGSize {
        if isOverrideIntrinsicContentSize {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        } else {
            return super.intrinsicContentSize
        }
    }
}


