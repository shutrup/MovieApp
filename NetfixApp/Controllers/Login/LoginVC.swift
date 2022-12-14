//
//  LoginVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import UIKit
import SnapKit

protocol AuthNavDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}

class LoginVC: UIViewController {
    
    let welcomeLabel = UILabel(text: "Добро пожаловать!", textColor: .white, font: .avenir26()!)
    
    let googleLabel = UILabel(text: "Войти через", textColor: .white, font: .avenir20()!)
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroungColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    
    let orLabel = UILabel(text: "или", textColor: .white, font: .avenir20()!)
    let emailLabel = UILabel(text: "Email", textColor: .white, font: .avenir20()!)
    let passwordLabel = UILabel(text: "Пароль", textColor: .white, font: .avenir20()!)
    
    let emailTF = OneLineTextField(font: .avenir20(), isSecureTextEntry: false)
    let passwordTF = OneLineTextField(font: .avenir20(), isSecureTextEntry: true)
   
    
    let loginButton = UIButton(title: "Войти", titleColor: .black, backgroungColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let needAccountLabel = UILabel(text: "Не зарегистрированы?", textColor: .white, font: .avenir16()!)
    let signUpButton = UIButton()
    


    weak var delegate: AuthNavDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        googleButton.customizeGoogleButton()
        loginButton.addTarget(self, action: #selector(showSetupProfile), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        
    }
    
    private func initView(){
        view.backgroundColor = .systemBackground
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.red, for: .normal)
        signUpButton.titleLabel?.font = .avenir16()
        
        view.addSubview(welcomeLabel)
        view.addSubview(googleLabel)
        view.addSubview(googleButton)
        view.addSubview(orLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(passwordLabel)
        view.addSubview(loginButton)
        view.addSubview(needAccountLabel)
        view.addSubview(signUpButton)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.centerX.equalToSuperview()
        }
        
        googleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(googleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        
        orLabel.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        emailTF.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTF.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        
        needAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(13)
            make.left.equalToSuperview().offset(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(7)
            make.left.equalTo(needAccountLabel.snp.right).offset(5)
        }
    }
    
    @objc func showSetupProfile(){
        AuthService.shared.login(email: emailTF.text, password: passwordTF.text) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case.success(let user):
                self.showAlert(with: "Успешно", and: "Вы авторизованы!") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result{
                        case .success(let users):
                            let mainvc = MainTabBarVC(current: users)
                            mainvc.modalPresentationStyle = .fullScreen
                            self.present(mainvc, animated: true)
                        case .failure(let error):
                            self.present(SetupProfileVC(currentUser: user), animated: true)
                            print(error.localizedDescription)
                        }
                    }
                   
                }
            case.failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    @objc func signUpButtonTapped(){
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}
