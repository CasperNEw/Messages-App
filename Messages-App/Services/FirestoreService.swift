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

    // подумать, может юзать структуру на вход
    func saveProfile(userId: String, username: String?, email: String, avatarPath: String?,
                     description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        guard Validator.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        // u can do better
        let mUser = MUser(userId: userId, username: username!, email: email,
                          avatarPath: "not exist", description: description!, sex: sex!)
        self.usersRef.document(mUser.userId).setData(mUser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(mUser))
            }
        }
    }

//    // Add a new document with a generated ID
//    var ref: DocumentReference? = nil
//    ref = db.collection("users").addDocument(data: [
//        "first": "Ada",
//        "last": "Lovelace",
//        "born": 1815
//    ]) { err in
//        if let err = err {
//            print("Error adding document: \(err)")
//        } else {
//            print("Document added with ID: \(ref!.documentID)")
//        }
//    }

}
