//
//  Extentions.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 03.08.2022.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
