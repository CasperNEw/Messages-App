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

    private var waitingChatsRef: CollectionReference? {
        guard let currentUser = currentUser else { return nil }
        return database.collection(["users", currentUser.userId, "waitingChats"].joined(separator: "/"))
    }

    private var activeChatsRef: CollectionReference? {
        guard let currentUser = currentUser else { return nil }
        return database.collection(["users", currentUser.userId, "activeChats"].joined(separator: "/"))
    }

    var currentUser: MUser?

    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, _ error) in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    completion(.failure(UserError.cannoUnwrapToMUser))
                    return
                }
                self.currentUser = mUser
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

    func createWaitingChat(message: String, to user: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = currentUser else { return }
        let reference = database.collection(["users", user.userId, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(currentUser.userId).collection("messages")

        let message = MMessage(user: currentUser, content: message)

        let chat = MChat(friendUsername: currentUser.username,
                         friendAvatarPath: currentUser.avatarPath,
                         lastMessage: message.content,
                         friendId: currentUser.userId)

        reference.document(currentUser.userId).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success(Void()))
            }
        }
    }

    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let waitingChatsRef = waitingChatsRef else { return }
        waitingChatsRef.document(chat.friendId).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }

    private func deleteMessages(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let reference = waitingChatsRef?.document(chat.friendId).collection("messages") else { return }
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.messageId else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            completion(.failure(error))
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getWaitingChatMessages(chat: MChat, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        let reference = waitingChatsRef?.document(chat.friendId).collection("messages")
        reference?.getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                return
            }

            var messages = [MMessage]()
            for document in querySnapshot.documents {
                guard let message = MMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }

    func changeToActiveChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { (result) in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result {
                    case .success:
                        self.createActiveChat(chat: chat, messages: messages) { (result) in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createActiveChat(chat: MChat, messages: [MMessage],
                                  completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = activeChatsRef?.document(chat.friendId).collection("messages")
        activeChatsRef?.document(chat.friendId).setData(chat.representation, completion: { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for message in messages {
                messageRef?.addDocument(data: message.representation, completion: { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                })
            }
        })
    }
}
