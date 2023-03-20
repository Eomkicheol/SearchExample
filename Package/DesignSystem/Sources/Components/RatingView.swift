//
//  RatingView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit
import SnapKit

import Common

public class RatingView: UIView {
    
    public var totalStars: Int = 5
    public var starSize: Int = 0
    public var starMargin: Int = 0
    
    public var halfStarImage: UIImage? = UIImage(systemName: "star.leadinghalf.filled")
    public var filledStarImage: UIImage? = UIImage(systemName: "star.fill")
    public var emptyStarImage: UIImage? = UIImage(systemName: "star")
    
    private var stars: [UIImageView] = []
    
    public var rating: Float = 0.0 {
        didSet {
            update(rating: rating)
        }
    }
    
    public func setupViews() {
        subviews.forEach { $0.removeFromSuperview() }
        stars.removeAll()
        
        (0..<totalStars).forEach { index in
            let star = UIImageView()
            star.image = emptyStarImage
            addSubview(star)
            
            star.snp.makeConstraints {
                $0.width.height.equalTo(starSize)
                $0.centerY.equalToSuperview()
                
                if stars.isEmpty {
                    $0.left.equalToSuperview()
                } else {
                    $0.left.equalTo(stars[index - 1].snp.right).offset(starMargin)
                }
            }
            stars.append(star)
        }
    }
    
    private func update(rating: Float) {
        for (index, star) in stars.enumerated() {
            let compare = Float(index + 1)
            if compare <= rating {
                star.image = filledStarImage
            } else {
                var decimal: Float = 1.0 - (compare - rating)
                decimal = decimal.roundToDecimal()
                
                if decimal >= 0.9 {
                    star.image = filledStarImage
                } else if decimal >= 0.5 {
                    star.image = halfStarImage
                } else {
                    star.image = emptyStarImage
                }
            }
        }
    }
}
