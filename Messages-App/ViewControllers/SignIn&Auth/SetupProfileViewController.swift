//
//  SetupProfileViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 25.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class SetupProfileViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Set up profile", font: .avenir26())
    let fullImageView = AddPhotoView()

    let fullNameLabel = UILabel(text: "Full Name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")

    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .buttonBlack())

    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupConstraints()
    }
}

// MARK: Setup constraints
extension SetupProfileViewController {
    private func setupConstraints() {

        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
                                            axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                            axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 5)

        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView,
                                                       sexStackView, goToChatsButton],
                                    axis: .vertical, spacing: 40)

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 15),

            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: SwiftUI
// Добавляем реализацию отображения нашего View через Canvas (alt+cmd+P, refresh combination)
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        // добавляем к нашему контейнеру метод игнорирования SafeArea, для адекватного, красивого, отображения
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let setupProfileVC = SetupProfileViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return setupProfileVC
        }
        func updateUIViewController(_ uiViewController: SetupProfileViewController, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_lenght
    }
}
