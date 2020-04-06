//
//  LoginViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 25.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Welcome Back!", font: .avenir26())

    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")

    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonBlack())
    let signUpButton = UIButton(title: "Sign up", titleColor: .buttonRed())

    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())

    weak var delegate: AuthNavigatingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        googleButton.addLogo(image: #imageLiteral(resourceName: "googleLogo"), leading: 24)
        setupConstraints()

        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    @objc func googleButtonTapped() {
        print(#function)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }

    @objc func loginButtonTapped() {
        print(#function)
        AuthService.shared.login(email: emailTextField.text!,
                                 password: passwordTextField.text!) { (result) in
                                    switch result {
                                    case .success(let user):
                                        self.showAlert(with: "Успешно!", and: "Вы авторизированы!") {
                                            FirestoreService.shared.getUserData(user: user) { (result) in
                                                switch result {
                                                case .success(let mUser):
                                                    let mainTabBar = MainTabBarController(currentUser: mUser)
                                                    mainTabBar.modalPresentationStyle = .fullScreen
                                                    self.present(mainTabBar, animated: true, completion: nil)
                                                case .failure(let error):
                                                    self.present(SetupProfileViewController(currentUser: user),
                                                                 animated: true, completion: nil)
                                                    print("[Error] \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        self.showAlert(with: "Damn!", and: error.localizedDescription)
                                    }
        }
    }
    @objc func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}

// MARK: Setup constraints
extension LoginViewController {
    private func setupConstraints() {
        let loginWithView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical, spacing: 0)

        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        let stackView = UIStackView(arrangedSubviews: [loginWithView, orLabel, emailStackView,
                                                       passwordStackView, loginButton],
                                    axis: .vertical, spacing: 40)

        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton],
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

            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

    }
}

// MARK: SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let loginVC = LoginViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) -> LoginViewController {
            return loginVC
        }
        func updateUIViewController(_ uiViewController: LoginViewController, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
