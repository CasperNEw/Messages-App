//
//  MChat.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

struct MChat: Hashable, Decodable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var identifier: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
