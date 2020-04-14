//
//  MMessage.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 13.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

struct MMessage: Hashable {

    let content: String
    let senderId: String
    let senderUsername: String
    let sentDate: Date //var?
    let messageId: String?

    init(user: MUser, content: String) {
        self.content = content
        self.senderId = user.userId
        self.senderUsername = user.username
        self.sentDate = Date()
        self.messageId = nil
    }

    var representation: [String: Any] {
        var representation: [String: Any] = [:]
        representation["content"] = content
        representation["senderId"] = senderId
        representation["senderUsername"] = senderUsername
        representation["sentDate"] = sentDate
//        representation["messageId"] = messageId
        return representation
    }
}
