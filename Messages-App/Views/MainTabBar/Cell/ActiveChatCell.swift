//
//  ActiveChatCell.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 26.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseIdentifier: String = "ActiveChatCell"

    let friendName = UILabel(text: "Melven Sandro", font: .laoSangamMN20())
    let friendImageView = UIImageView()
    let lastMessage = UILabel(text: "Hello!", font: .laoSangamMN18())
    let gradientView = GradientView(fromPoint: .topTrailing, toPoint: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with value: MChat) {
        friendName.text = value.username
        lastMessage.text = value.lastMessage
        friendImageView.image = UIImage(named: value.userImageString)

    }
}

// MARK: Setup constraints
extension ActiveChatCell {

    private func setupConstraints() {

        friendName.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        friendImageView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        gradientView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)

        addSubview(friendImageView)
        addSubview(gradientView)
        addSubview(friendName)
        addSubview(lastMessage)

        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78),

            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: self.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 8),

            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),

            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
    }
}

// MARK: SwiftUI
import SwiftUI

struct ActiveChatProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: ActiveChatProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) {
        }
        // swiftlint:enable line_lenght
    }
}
