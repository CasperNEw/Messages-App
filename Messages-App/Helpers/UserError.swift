//
//  UserError.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 03.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannoUnwrapToMUser
    case cannotGetUserInfo
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Добавьте фотографию", comment: "")
        case .cannoUnwrapToMUser:
            return NSLocalizedString("Невозможно конвертировать данные из базы данных", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию о пользовтеле из базы данных", comment: "")
        }
    }
}
