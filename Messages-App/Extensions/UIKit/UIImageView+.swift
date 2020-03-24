//
//  UIImageView+.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 24.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIImageView {

    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()

        self.image = image
        self.contentMode = contentMode
    }
}
