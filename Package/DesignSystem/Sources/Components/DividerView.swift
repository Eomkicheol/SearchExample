//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import SnapKit

public class DividerView: UIView {
    
    private var spacing: CGFloat = 0
    
    public init(frame: CGRect, spacing: CGFloat) {
        super.init(frame: frame)
        
        self.spacing = spacing
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        UIColor.systemGray2.set()
        path.move(to: CGPoint(x: spacing, y: 0))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width - spacing, y: 0))
        path.lineWidth = 0.5
        path.close()
        path.stroke()
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        self.snp.makeConstraints {
            $0.height.equalTo(5)
        }
    }
}

