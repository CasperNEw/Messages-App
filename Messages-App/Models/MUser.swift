//
//  MUser.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

struct MUser: Hashable, Decodable {

    var username: String
    var avatarStringURL: String
    var identifier: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
