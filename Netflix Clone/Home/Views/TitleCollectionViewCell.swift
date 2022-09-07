//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 25/08/22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func configure(model: String) {
        let url = ImageSize.small.url.appendingPathComponent(model)
        posterImageView.sd_setImage(with: url)
    }
}
