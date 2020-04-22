//
//  MChat.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct MChat: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarPath: String
    var lastMessage: String
    var friendId: String

    var representation: [String: Any] {
        var representation = ["friendUsername": friendUsername]
        representation["friendAvatarPath"] = friendAvatarPath
        representation["lastMessage"] = lastMessage
        representation["friendId"] = friendId
        return representation
    }

    init(friendUsername: String, friendAvatarPath: String, lastMessage: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendAvatarPath = friendAvatarPath
        self.lastMessage = lastMessage
        self.friendId = friendId
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
            let friendAvatarPath = data["friendAvatarPath"] as? String,
            let lastMessage = data["lastMessage"] as? String,
            let friendId = data["friendId"] as? String else { return nil }

        self.friendUsername = friendUsername
        self.friendAvatarPath = friendAvatarPath
        self.lastMessage = lastMessage
        self.friendId = friendId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }

    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }

    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        return friendUsername.lowercased().contains(filter.lowercased())
    }
}
