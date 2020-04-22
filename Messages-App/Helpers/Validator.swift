//
//  Validator.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 01.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

class Validator {

    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let email = email, let password = password, let confirmPassword = confirmPassword,
            !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else { return false }
        return true
    }

    static func isFilled(username: String?, description: String?, sex: String?) -> Bool {
        guard let username = username, let description = description, let sex = sex,
            !username.isEmpty, !description.isEmpty, !sex.isEmpty else { return false }
        return true
    }

    static func isSimpleEmail(email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }

    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
