//
//  File.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 14.08.2022.
//

import Foundation
import UIKit

final class AppliactionUtility {
    
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else  {
            return .init()
        }
        
        return root
    }
}
