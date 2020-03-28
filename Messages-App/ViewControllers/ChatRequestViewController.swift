//
//  ChatRequestViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 28.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ChatRequestViewController: UIViewController {

    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human3"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Leeloo Dallas", font: .systemFont(ofSize: 20, weight: .light))
    let aboutLabel = UILabel(text: "Multipass", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, backgroundColor: .black,
                                font: .laoSangamMN20(), isShadow: false, cornerRadius: 10)
    let denyButton = UIButton(title: "Deny", titleColor: #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1), backgroundColor: .mainWhite(),
                              font: .laoSangamMN20(), isShadow: false, cornerRadius: 10)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        setupViews()
        setupConstraints()
    }
}

// MARK: Setup constraints
extension ChatRequestViewController {

    private func setupViews() {

        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false

        aboutLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainWhite()

        denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
        denyButton.layer.borderWidth = 1.2

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acceptButton.applyGradient(cornerRadius: 10)
    }

    private func setupConstraints() {

        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutLabel)

        let buttonStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 10)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        containerView.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206),

            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),

            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),

            aboutLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            aboutLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),

            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonStackView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

// MARK: SwiftUI
import SwiftUI

struct ChatRequestVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let chatRequestVC = ChatRequestViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatRequestVCProvider.ContainerView>) -> ChatRequestViewController {
            return chatRequestVC
        }
        func updateUIViewController(_ uiViewController: ChatRequestViewController, context: UIViewControllerRepresentableContext<ChatRequestVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_lenght
    }
}
