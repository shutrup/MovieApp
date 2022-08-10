//
//  OneLineTextField + Extns.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import Foundation
import UIKit
import SnapKit
class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .avenir20()){
        self.init()
        
        self.font = font
        self.borderStyle = .none
        
        var bottomView = UIView()
        bottomView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = UIColor(hexString: "#E6E6E6")
        self.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
