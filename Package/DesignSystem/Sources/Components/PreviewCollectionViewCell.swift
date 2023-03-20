//
//  PreviewCollectionViewCell.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import UIKit
import SnapKit
import Then
import ImageLoader

public class PreviewCollectionViewCell: UICollectionViewCell {
    
    let previewImageView = RoundedImageView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        previewImageView.borderColor = .systemGray6
        previewImageView.radiusRatio = 15
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        [previewImageView].forEach {
            self.contentView.addSubview($0)
        }
        
        previewImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(with url: String) {
        previewImageView.setImage(urlString: url)
    }
}
