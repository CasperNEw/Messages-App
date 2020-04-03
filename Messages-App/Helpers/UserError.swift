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
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Добавьте фотографию", comment: "")
        }
    }
}
