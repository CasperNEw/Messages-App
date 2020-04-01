//
//  AuthService.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 01.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()

    func login(email: String?, password: String?, complition: @escaping (Result<User, Error>) -> Void) {

        guard let email = email, let password = password else {
            complition(.failure(AuthError.notFilled))
            return
        }
        if email.isEmpty || password.isEmpty {
            complition(.failure(AuthError.notFilled))
            return
        }

        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                complition(.failure(error!))
                return
            }
            complition(.success(result.user))
        }
    }

    func register(email: String?, password: String?, confirmPassword: String?,
                  complition: @escaping (Result<User, Error>) -> Void) {

        guard Validator.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            complition(.failure(AuthError.notFilled))
            return
        }

        if password != confirmPassword {
            complition(.failure(AuthError.passwordsNotMatched))
            return
        }

        if !Validator.isSimpleEmail(email: email) {
            complition(.failure(AuthError.invalidEmail))
            return
        }

        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                complition(.failure(error!))
                return
            }
            complition(.success(result.user))
        }
    }
}
