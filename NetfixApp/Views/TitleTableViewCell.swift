//
//  TitleTableViewCell.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 03.08.2022.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {

    static let id = "TitleTableViewCell"
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titlesPosterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func applyConstraints(){
        let titleImage = [
            titlesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titlesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlesPosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabel = [
            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterImageView.trailingAnchor, constant:  20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
             
        ]
        
        let playButton = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titleImage)
        NSLayoutConstraint.activate(titleLabel)
        NSLayoutConstraint.activate(playButton)
    }
    
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        
        titlesPosterImageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
    
}
