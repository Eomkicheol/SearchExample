//
//  VerticalDividerView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

public class VerticalDividerView: UIView {
    
    private(set) var height: CGFloat = 0
    private(set) var spacing: CGFloat = 0
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, spacing: CGFloat, height: CGFloat) {
        super.init(frame: frame)
        
        self.spacing = spacing
        self.height = height
        setupViews()
    }

    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        UIColor.systemGray2.set()
        path.move(to: CGPoint(x: 0, y: spacing))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.lineWidth = 0.5
        path.close()
        path.stroke()
    }
    
    private func setupViews() {
        backgroundColor = .white
        snp.makeConstraints {
            $0.width.equalTo(1)
        }
    }
}



