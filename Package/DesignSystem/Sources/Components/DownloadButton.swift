//
//  DownloadButton.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import Foundation

import UIKit

public class DownloadButton: RoundedButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        radiusRatio = 13
        leftInset = 15
        rightInset = 15
        setTitle("받기", for: .normal)
        backgroundColor = .systemBlue
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
}
