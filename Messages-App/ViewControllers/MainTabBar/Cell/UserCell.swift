//
//  UserCell.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseIdentifier: String = "UserCell"
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "Username", font: .laoSangamMN20())
    let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.cornerRadius = 4

        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }

    func configure<U>(with value: U) where U: Hashable {
        guard let user = value as? MUser else { return }
        friendImageView.image = UIImage(named: user.avatarPath)
        friendName.text = user.username
       }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup constraints
extension UserCell {

    private func setupConstraints() {

        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(friendImageView)
        containerView.addSubview(friendName)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            friendImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            friendImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),

            friendName.topAnchor.constraint(equalTo: friendImageView.bottomAnchor),
            friendName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            friendName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            friendName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8)
        ])
    }
}

// MARK: SwiftUI
import SwiftUI

struct UserCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<UserCellProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: UserCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UserCellProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
