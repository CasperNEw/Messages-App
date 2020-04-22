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
import GoogleSignIn

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()

    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {

        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        if email.isEmpty || password.isEmpty {
            completion(.failure(AuthError.notFilled))
            return
        }

        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }

    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<User, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)

        Auth.auth().signIn(with: credential) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }

    func register(email: String?, password: String?, confirmPassword: String?,
                  completion: @escaping (Result<User, Error>) -> Void) {

        guard Validator.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }

        if password != confirmPassword {
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }

        if !Validator.isSimpleEmail(email: email) {
            completion(.failure(AuthError.invalidEmail))
            return
        }

        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
