//
//  GenresCollection.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 06.08.2022.
//

import UIKit

class GenresCollection: UICollectionViewCell {
    
    static let id = "Cell"
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(genreLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        genreLabel.frame = contentView.bounds
        genreLabel.textAlignment = .center
    }
    
    public func configure(with model: Genre){
        genreLabel.text = model.name
    }
    
}
