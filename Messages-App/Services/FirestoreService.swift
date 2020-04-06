//
//  FirestoreService.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 03.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Firebase
import FirebaseFirestore

class FirestoreService {

    static let shared = FirestoreService()
    let database = Firestore.firestore()

    private var usersRef: CollectionReference {
        return database.collection("users")
    }

    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, _ error) in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    completion(.failure(UserError.cannoUnwrapToMUser))
                    return
                }
                completion(.success(mUser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }

    // swiftlint:disable function_parameter_count
    func saveProfile(userId: String, username: String?, email: String, avatarImage: UIImage?,
                     description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        guard Validator.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }

        guard let username = username, let description = description, let sex = sex else {
            completion(.failure(UserError.notFilled))
            return
        }

        guard let avatarImage = avatarImage, avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }

        var mUser = MUser(userId: userId, username: username, email: email,
                          avatarPath: "not exist", description: description, sex: sex)

        StorageService.shared.upload(image: avatarImage) { (result) in
            switch result {
            case .success(let url):
                mUser.avatarPath = url.absoluteString
                self.usersRef.document(mUser.userId).setData(mUser.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(mUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    // swiftlint:enable function_parameter_count
}
