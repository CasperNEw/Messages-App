//
//  MMessage.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 13.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MMessage: Hashable, MessageType {

    let content: String
    let sentDate: Date
    var sender: SenderType
    let messageId: String
    var kind: MessageKind {
        return .text(content)
    }

    init(user: MUser, content: String) {
        self.content = content
        self.sender = user as SenderType
        self.sentDate = Date()
        self.messageId = UUID().uuidString
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let content = data["content"] as? String,
        let senderId = data["senderId"] as? String,
        let senderUsername = data["senderUsername"] as? String,
        let sentDate = data["sentDate"] as? Timestamp else { return nil }

        self.content = content
        self.sender = MUserSType(senderId: senderId, displayName: senderUsername)
        self.sentDate = sentDate.dateValue()
        self.messageId = document.documentID
    }

    var representation: [String: Any] {
        var representation: [String: Any] = [:]
        representation["content"] = content
        representation["senderId"] = sender.senderId
        representation["senderUsername"] = sender.displayName
        representation["sentDate"] = sentDate
        return representation
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        lhs.messageId == rhs.messageId
    }
}
