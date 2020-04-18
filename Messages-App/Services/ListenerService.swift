//
//  ListenerService.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 13.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {

    static let shared = ListenerService()
    let database = Firestore.firestore()

    private var usersRef: CollectionReference {
        return database.collection("users")
    }

    private var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }

    func usersObeserve(users: [MUser],
                       completion: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration? {

        var users = users
        let usersListener = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let mUser = MUser(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !users.contains(mUser) else { return }
                    guard mUser.userId != self.currentUserId else { return }
                    users.append(mUser)
                case .modified:
                    guard let index = users.firstIndex(of: mUser) else { return }
                    users[index] = mUser
                case .removed:
                    guard let index = users.firstIndex(of: mUser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }

    func witingChatsObeserve(chats: [MChat],
                             completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration? {

        guard let currentUserId = currentUserId else { return nil }
        var chats = chats
        let chatsRef = database.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))

        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let mChat = MChat(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !chats.contains(mChat) else { return }
                    chats.append(mChat)
                case .modified:
                    guard let index = chats.firstIndex(of: mChat) else { return }
                    chats[index] = mChat
                case .removed:
                    guard let index = chats.firstIndex(of: mChat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }
}
