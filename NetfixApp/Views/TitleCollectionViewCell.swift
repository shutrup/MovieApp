//
//  TitleCollectionViewCell.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 03.08.2022.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let id = "TitleCollectionViewCell"
    
    private let posterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImage)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImage.frame = contentView.bounds
    }
    
    public func configure(with model: String){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
        posterImage.sd_setImage(with: url)
    }
}
