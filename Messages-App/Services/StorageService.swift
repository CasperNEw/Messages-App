//
//  StorageService.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 06.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {

    static let shared = StorageService()

    let storageRef = Storage.storage().reference()

    private var avatarRef: StorageReference {
        return storageRef.child("avatars")
    }

    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? StorageError.nilUserId.localizedDescription
    }

    func upload(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {

        guard let scaledImage = image.scaledToSafeUploadImage,
            let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        avatarRef.child(currentUserId).putData(imageData, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                completion(.failure(error ?? StorageError.nilResponse))
                return
            }

            self.avatarRef.child(self.currentUserId).downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    completion(.failure(error ?? StorageError.nilResponse))
                    return
                }
                completion(.success(downloadUrl))
            }
        }
    }
}
