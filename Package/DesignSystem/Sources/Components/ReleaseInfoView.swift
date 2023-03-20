//
//  ReleaseInfoView.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit

import Then
import SnapKit
import Common

public class ReleaseInfoView: UIView {
    
    let appVersionLabel = UILabel().then {
        $0.textColor = .systemGray3
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.numberOfLines = 1
    }
    
    let appReleaseDateLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public func setup(version: String?, date: String?) {
        appVersionLabel.text = version
        if let date = date {
            let today = Date()
            let releaseDate = date.stringToDate()
            let interval = today.timeIntervalSince(releaseDate)
            let days = Int(interval / 86400)
            appReleaseDateLabel.text = releaseDate.convertToReleaseGapFormatter(fromToday: today, days: days)
        }
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        [appVersionLabel, appReleaseDateLabel].forEach {
            self.addSubview($0)
        }
        
        appVersionLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(18)
        }
        
        appReleaseDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(appVersionLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
    }
}

