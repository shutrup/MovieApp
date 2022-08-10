//
//  ProfileScreenVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 10.08.2022.
//

import UIKit
import SnapKit

class ProfileScreenVC: UIViewController {
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "people-1241171")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 100
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0.2
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.shadowColor = UIColor.white.cgColor
        image.layer.shadowRadius = 8
        image.layer.shadowOpacity = 0.3
        image.layer.shadowOffset = CGSize(width: 0, height: 8)
        return image
    }()
    
    let profileNameLabel = UILabel(text: "Name Name", textColor: .white, font: .avenir20()!)
    let favoriteMovieLabel = UILabel(text: "Любимые фильмы:", textColor: .white, font: .avenir16()!)
    
    let favoritesMovieCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FavoritesMovieCell.self, forCellWithReuseIdentifier: FavoritesMovieCell.id)
        return collection
    }()
    
    let movies: [String] = ["что то","что то","что то","что то","что то"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(favoriteMovieLabel)
        view.addSubview(favoritesMovieCollection)
        favoritesMovieCollection.delegate = self
        favoritesMovieCollection.dataSource = self
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        favoriteMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNameLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(50)
        }
        
        favoritesMovieCollection.snp.makeConstraints { make in
            make.top.equalTo(favoriteMovieLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
    }
    
}

extension ProfileScreenVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesMovieCell.id, for: indexPath) as? FavoritesMovieCell else { return UICollectionViewCell()}
        cell.favoriteMovieName.text = movies[indexPath.row]
        return cell
    }
    
    
}
