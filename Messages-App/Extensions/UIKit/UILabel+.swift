//
//  UILabel+.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 24.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()

        self.text = text
        self.font = font
    }
}
