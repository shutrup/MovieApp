//
//  UIAppliacation + Extentions.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 14.08.2022.
//

import Foundation
import UIKit

extension UIApplication{
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController{
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController{
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController{
            return getTopViewController(base: presented)
        }
        return base
    }
}
