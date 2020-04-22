//
//  StorageError.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 06.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case nilUserId
    case nilResponse
}

extension StorageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nilUserId:
            return NSLocalizedString("Отсутствует currentUser.uid", comment: "")
        case .nilResponse:
            return NSLocalizedString("Пустой ответ от сервера", comment: "")
        }
    }
}
