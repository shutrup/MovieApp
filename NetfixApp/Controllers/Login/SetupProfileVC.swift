//
//  SetupProfileVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import UIKit

class SetupProfileVC: UIViewController {
    
    let setUpProfileLabel = UILabel(text: "Настройка профиля!", textColor: .white, font: .avenir26()!)
    let fullNameLabel = UILabel(text: "Полное имя", textColor: .white, font: .avenir20()!)
    let favoriteMovieLabel = UILabel(text: "Любимые фильмы", textColor: .white, font: .avenir20()!)
    let fullNameTF = OneLineTextField(font: .avenir20())
    let favoriteMovieTF = OneLineTextField(font: .avenir20())
    let loginButton = UIButton(title: "Сохранить", titleColor: .black, backgroungColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    
    let fillImageView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupContraints()
    }
    
    private func initView(){
        view.backgroundColor = .systemBackground
        
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
