//
//  WaitingChatsNavigation.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 18.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol WaitingChatsNavigation: AnyObject {
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}
