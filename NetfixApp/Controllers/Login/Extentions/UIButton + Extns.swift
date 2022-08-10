//
//  UIButton + Extns.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import Foundation
import UIKit
import SnapKit
extension UIButton {
    convenience init(title: String,
                     titleColor: UIColor,
                     backgroungColor: UIColor,
                     font: UIFont?,
                     isShadow: Bool,
                     cornerRadius: CGFloat){
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroungColor
        self.titleLabel?.font = font
        
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.white.cgColor
            self.layer.shadowRadius = 8
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize(width: 0, height: 8)
        }
    }
    
    func customizeGoogleButton(){
        let googleLogo = UIImageView(image: UIImage(named: "google")!, contentMode: .scaleAspectFit)
        addSubview(googleLogo)
        
        googleLogo.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
    }
    
    func customizeEmailButton(){
        let googleLogo = UIImageView(image: UIImage(named: "mail")!, contentMode: .scaleAspectFit)
        addSubview(googleLogo)
        
        googleLogo.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
    }
}
