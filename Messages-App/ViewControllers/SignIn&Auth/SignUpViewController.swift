//
//  SignUpViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 24.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Good to see you!", font: .avenir26())

    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")

    let signUpButton = UIButton(title: "Sign up", titleColor: .white, backgroundColor: .buttonBlack())
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed())

    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupConstraints()

        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    @objc func signUpButtonTapped() {
        print(#function)
        AuthService.shared.register(email: emailTextField.text,
                                    password: passwordTextField.text,
                                    confirmPassword: confirmPasswordTextField.text) { (result) in
            switch result {
            case .success(let user):
                print(user.email as Any)
                self.showAlert(with: "Complete", and: "Congratiluation! You are register!")
            case .failure(let error):
                self.showAlert(with: "Damn", and: error.localizedDescription)
            }
        }
    }
}

// MARK: Setup constraints
extension SignUpViewController {
    private func setupConstraints() {

        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField],
                                                   axis: .vertical, spacing: 0)

        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView,
                                                       confirmPasswordStackView, signUpButton],
                                    axis: .vertical, spacing: 40)

        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton],
                                          axis: .horizontal, spacing: 5)

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 120),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
}

// MARK: SwiftUI
import SwiftUI

struct SignUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let signUpVC = SignUpViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainerView>) -> SignUpViewController {
            return signUpVC
        }
        func updateUIViewController(_ uiViewController: SignUpViewController, context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
