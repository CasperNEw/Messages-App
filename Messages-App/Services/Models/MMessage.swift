//
//  MMessage.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 13.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import FirebaseFirestore

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

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let content = data["content"] as? String,
        let senderId = data["senderId"] as? String,
        let senderUsername = data["senderUsername"] as? String,
        let sentDate = data["sentDate"] as? Timestamp else { return nil }

        self.content = content
        self.senderId = senderId
        self.senderUsername = senderUsername
        self.sentDate = sentDate.dateValue()
        self.messageId = document.documentID
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
