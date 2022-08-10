//
//  UILabel + Extns.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String,
                     textColor: UIColor,
                     font: UIFont){
        self.init()
        
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
