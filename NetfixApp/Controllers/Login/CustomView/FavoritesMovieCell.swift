//
//  FavoritesMovieCell.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 10.08.2022.
//

import UIKit

class FavoritesMovieCell: UICollectionViewCell {
    static let id = "cell"
    let favoriteMovieName = UILabel(text: "asdf", textColor: .white, font: .avenir20()!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(favoriteMovieName)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        favoriteMovieName.frame = contentView.bounds
        favoriteMovieName.textAlignment = .center
    }
}
