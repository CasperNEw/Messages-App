//
//  SelfConfiguringCell.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 26.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with value: MChat)
}
