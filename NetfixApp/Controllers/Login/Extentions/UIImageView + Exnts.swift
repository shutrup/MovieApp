//
//  UIImageView + Exnts.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 09.08.2022.
//

import Foundation
import UIKit

extension UIImageView {
    convenience init(image: UIImage, contentMode: UIView.ContentMode){
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}
