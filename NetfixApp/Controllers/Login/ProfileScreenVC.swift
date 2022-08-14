//
//  ProfileScreenVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 10.08.2022.
//

import UIKit
import SnapKit
import FirebaseAuth

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
    let favoriteMovieLabel = UILabel(text: "Любимые фильмы:", textColor: .white, font: .avenir20()!)
    
    
    private let currentUser: Users
    
    init(currentUser: Users){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        profileNameLabel.text = currentUser.username
        favoriteMovieLabel.text = currentUser.description
        guard let imageUrl = URL(string: currentUser.avatarStringUrl) else {return}
        print(imageUrl)
        profileImageView.sd_setImage(with: imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc private func signOut(){
        let ac = UIAlertController(title: nil, message: "Вы точно хотите выйти?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthVC()
            }catch{
                print("Error sign out")
            }
        }))
        
        present(ac, animated: true)
    }
    
    private func initView(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(favoriteMovieLabel)
        
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
        
        
    }
    
}
