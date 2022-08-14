//
//  SignUpVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import UIKit

class SignUpVC: UIViewController {
    
    let welcomeLabel = UILabel(text: "Рад вас видеть!", textColor: .white, font: .avenir26()!)
    
    let emailLabel = UILabel(text: "Email", textColor: .white, font: .avenir20()!)
    let passwordLabel = UILabel(text: "Пароль", textColor: .white, font: .avenir20()!)
    let confirPasswordLabel = UILabel(text: "Подвердить пароль", textColor: .white, font: .avenir20()!)
    let alreadyOnboardLabel = UILabel(text: "Уже зарегистрированы?", textColor: .white, font: .avenir16()!)
    
    let emailTF = OneLineTextField(font: .avenir20(), isSecureTextEntry: false)
    let passwordTF = OneLineTextField(font: .avenir20(), isSecureTextEntry: true)
    let confirmPasswordTF = OneLineTextField(font: .avenir20(), isSecureTextEntry: true)
    
    let signButton = UIButton(title: "Sign up", titleColor: .black, backgroungColor: .white, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let loginButton = UIButton()
    
    weak var delegate: AuthNavDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        signButton.addTarget(self, action: #selector(signInButtonTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
    }
    
    @objc func signInButtonTap(){
        AuthService.shared.register(email: emailTF.text, password: passwordTF.text, confirmPassword: confirmPasswordTF.text) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case.success(let user):
                self.showAlert(with: "Успешно", and: "Вы зарегистрированы!") {
                    self.present(SetupProfileVC(currentUser: user), animated: true)
                }
                
            case.failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    @objc func loginButtonTap(){
        self.dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
    
    private func initView(){
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(confirPasswordLabel)
        view.addSubview(alreadyOnboardLabel)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(confirmPasswordTF)
        view.addSubview(signButton)
        view.addSubview(loginButton)
        
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.red, for: .normal)
        loginButton.titleLabel?.font = .avenir16()
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(130)
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
        
        confirPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        confirmPasswordTF.snp.makeConstraints { make in
            make.top.equalTo(confirPasswordLabel.snp.bottom)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTF.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        
        alreadyOnboardLabel.snp.makeConstraints { make in
            make.top.equalTo(signButton.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(signButton.snp.bottom).offset(54)
            make.left.equalTo(alreadyOnboardLabel.snp.right).offset(3)
        }
    }
}

extension UIViewController{
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = {}){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
