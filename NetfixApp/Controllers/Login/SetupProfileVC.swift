//
//  SetupProfileVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import UIKit
import FirebaseAuth

class SetupProfileVC: UIViewController {
    
    let setUpProfileLabel = UILabel(text: "Настройка профиля!", textColor: .white, font: .avenir26()!)
    let fullNameLabel = UILabel(text: "Полное имя", textColor: .white, font: .avenir20()!)
    let favoriteMovieLabel = UILabel(text: "Любимые фильмы", textColor: .white, font: .avenir20()!)
    let fullNameTF = OneLineTextField(font: .avenir20())
    let favoriteMovieTF = OneLineTextField(font: .avenir20())
    let loginButton = UIButton(title: "Сохранить", titleColor: .black, backgroungColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    
    let fillImageView = AddPhotoView()
    
    private let currentUser: User
    
    init(currentUser: User){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupContraints()
    }
    
    private func initView(){
        view.backgroundColor = .systemBackground
        loginButton.addTarget(self, action: #selector(saveDataOnFirestore), for: .touchUpInside)
    }
    
    @objc private func saveDataOnFirestore(){
        FirestoreService.shared.saveProfileWith(id: currentUser.uid, email: currentUser.email!, username: fullNameTF.text!, avatarImageString: "nil", description: favoriteMovieTF.text!) { result in
            switch  result{
            case .success(let users):
                self.showAlert(with: "Успешно", and: "Данные сохранены)!") {
                    let mainvc = MainTabBarVC(current: users)
                    mainvc.modalPresentationStyle = .fullScreen
                    self.present(mainvc, animated: true)
                }
                print(users.email)
            case.failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    
}

extension SetupProfileVC {
    private func setupContraints(){
        view.addSubview(fillImageView)
        view.addSubview(setUpProfileLabel)
        view.addSubview(fullNameLabel)
        view.addSubview(fullNameTF)
        view.addSubview(favoriteMovieLabel)
        view.addSubview(favoriteMovieTF)
        view.addSubview(loginButton)
        
        setUpProfileLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.centerX.equalToSuperview()
        }
        
        fillImageView.snp.makeConstraints { make in
            make.top.equalTo(setUpProfileLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(fillImageView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        fullNameTF.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        favoriteMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameTF.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        favoriteMovieTF.snp.makeConstraints { make in
            make.top.equalTo(favoriteMovieLabel.snp.bottom)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(favoriteMovieTF.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        
    }
}
