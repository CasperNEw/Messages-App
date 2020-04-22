//
//  MUser.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MUser: Hashable, Decodable, SenderType {

    var userId: String
    var username: String
    var email: String
    var avatarPath: String
    var description: String
    var sex: String

    var senderId: String { return userId }
    var displayName: String { return username }

    init(userId: String, username: String, email: String, avatarPath: String, description: String, sex: String) {
        self.userId = userId
        self.username = username
        self.email = email
        self.avatarPath = avatarPath
        self.description = description
        self.sex = sex
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let userId = data["userId"] as? String,
        let username = data["username"] as? String,
        let email = data["email"] as? String,
        let avatarPath = data["avatarPath"] as? String,
        let description = data["description"] as? String,
        let sex = data["sex"] as? String else { return nil }

        self.userId = userId
        self.username = username
        self.email = email
        self.avatarPath = avatarPath
        self.description = description
        self.sex = sex
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let userId = data["userId"] as? String,
        let username = data["username"] as? String,
        let email = data["email"] as? String,
        let avatarPath = data["avatarPath"] as? String,
        let description = data["description"] as? String,
        let sex = data["sex"] as? String else { return nil }

        self.userId = userId
        self.username = username
        self.email = email
        self.avatarPath = avatarPath
        self.description = description
        self.sex = sex
    }

    var representation: [String: Any] {
        var representation = ["userId": userId]
        representation["username"] = username
        representation["email"] = email
        representation["avatarPath"] = avatarPath
        representation["description"] = description
        representation["sex"] = sex
        return representation
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }

    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.userId == rhs.userId
    }

    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        return username.lowercased().contains(filter.lowercased())
    }
}

//альтернатива Sender из MessageKit pod, реализована в MMessage init?(QueryDocumentSnapshot)
struct MUserSType: SenderType {
    var senderId: String
    var displayName: String

    init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }
}
