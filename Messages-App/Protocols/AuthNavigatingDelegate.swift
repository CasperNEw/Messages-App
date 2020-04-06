//
//  AuthNavigatingDelegate.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 06.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

protocol AuthNavigatingDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
