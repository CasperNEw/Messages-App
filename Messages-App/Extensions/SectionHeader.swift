//
//  SectionHeader.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    static let reuseIdentifier = "SectionHeader"
    let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configure(text: String, font: UIFont?, color: UIColor) {
        title.text = text
        title.font = font
        title.textColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
