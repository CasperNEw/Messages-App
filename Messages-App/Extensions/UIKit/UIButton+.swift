//
//  UIButton+.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 24.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont? = .avenir20(),
                     isShadow: Bool = false,
                     cornerRadius: CGFloat = 4) {
        self.init(type: .system)

        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius

        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }

    convenience init(title: String, titleColor: UIColor, font: UIFont? = .avenir20()) {
        self.init(type: .system)

        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
    }

    func addLogo(image: UIImage, leading: CGFloat) {
        let logo = UIImageView(image: image, contentMode: .scaleAspectFit)
        logo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logo)

        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading),
            logo.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
