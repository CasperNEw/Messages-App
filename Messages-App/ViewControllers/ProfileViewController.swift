//
//  ProfileViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 28.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human7"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Brain O'Conner", font: .systemFont(ofSize: 20, weight: .light))
    let aboutLabel = UILabel(text: "Find new skyline...", font: .systemFont(ofSize: 16, weight: .light))
    let textField = InsertableTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        setupViews()
        setupConstraints()
    }
}

// MARK: Setup constraints
extension ProfileViewController {

    private func setupViews() {

        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        aboutLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainWhite()

        if let button = textField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }

    }

    @objc private func sendMessage() {
        print(#function)
    }

    private func setupConstraints() {

        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutLabel)
        containerView.addSubview(textField)

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

            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textField.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: SwiftUI
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let profileVC = ProfileViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) -> ProfileViewController {
            return profileVC
        }
        func updateUIViewController(_ uiViewController: ProfileViewController, context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_lenght
    }
}
