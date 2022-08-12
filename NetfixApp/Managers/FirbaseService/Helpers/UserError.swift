//
//  UserError.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 11.08.2022.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToUser
}

extension UserError: LocalizedError {
    var errorDescription: String?{
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Пользователь не выбрал фото", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию о User из Firebase", comment: "")
        case .cannotUnwrapToUser:
            return NSLocalizedString("Невозможно конвертировать Users из User", comment: "")
        }
        
    }
}
