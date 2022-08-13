//
//  UIImage + Extentions.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 12.08.2022.
//

import Foundation
import  UIKit

extension UIImage {
    var scaledTosafeUploadSize: UIImage? {
        let maxImageSize: CGFloat = 480
        
        let largeSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largeSide > maxImageSize ? largeSide / maxImageSize : 1
        let newImageSize = CGSize(width: size.width/ratioScale, height: size.height/ratioScale)
        
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize ) -> UIImage{
        defer{
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
