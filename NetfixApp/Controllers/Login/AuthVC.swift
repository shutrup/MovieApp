//
//  AuthVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import UIKit
import SnapKit
import GoogleSignIn
import Firebase

class AuthVC: UIViewController {

    let logoImageView = UIImageView(image: UIImage(named: "pixlr-bg-result")!, contentMode: .scaleAspectFill)
    
    let googleLabel = UILabel(text: "Начать с", textColor: .white, font: .avenir16()!)
    let emailLabel = UILabel(text: "Или зарегистрируйтесь с", textColor: .white, font: .avenir16()!)
    let loginLabel = UILabel(text: "Уже зарегистрированы?", textColor: .white, font: .avenir16()!)
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroungColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroungColor:  UIColor(hexString: "#333333"), font: .avenir20(), isShadow: true, cornerRadius: 4)
    let loginButton = UIButton(title: "Войти", titleColor: UIColor(hexString: "#D0021B"), backgroungColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let signUpVC = SignUpVC()
    let loginVC = LoginVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        googleButton.customizeGoogleButton()
        emailButton.customizeEmailButton()
        emailButton.addTarget(self, action: #selector(showEmail), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
        
    }
    
    
    
    private func initView(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImageView)
        view.addSubview(googleLabel)
        view.addSubview(emailLabel)
        view.addSubview(loginLabel)
        view.addSubview(googleButton)
        view.addSubview(emailButton)
        view.addSubview(loginButton)
        
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(45)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(130)
            make.left.right.equalToSuperview().offset(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        
        googleLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview().offset(40)
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(googleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview().offset(40)
        }
        
        emailButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        
    }
    
    @objc func showEmail(){
       
        present(signUpVC, animated: true)
    }
    
    @objc func showLogin(){
        present(loginVC, animated: true)
    }
}

extension AuthVC: AuthNavDelegate {
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true)
    }
}

