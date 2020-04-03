//
//  MUser.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

struct MUser: Hashable, Decodable {

    var userId: String
    var username: String
    var email: String
    var avatarPath: String
    var description: String
    var sex: String

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
