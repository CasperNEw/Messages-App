//
//  AuthViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 24.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {

    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)

    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let loginLabel = UILabel(text: "Already onboard?")

    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonBlack())
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true)

    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        googleButton.addLogo(image: #imageLiteral(resourceName: "googleLogo"), leading: 24)
        setupConstraints()

        signUpVC.delegate = self
        loginVC.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self

        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    @objc func googleButtonTapped() {
        print(#function)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()

    }
    @objc func emailButtonTapped() {
        print(#function)
        present(signUpVC, animated: true, completion: nil)
    }
    @objc func loginButtonTapped() {
        print(#function)
        present(loginVC, animated: true, completion: nil)
    }
}

// MARK: Setup constraints
extension AuthViewController {

    private func setupConstraints() {

        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: loginLabel, button: loginButton)

        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(logoImageView)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
// MARK: AuthNavigatingDelegate
extension AuthViewController: AuthNavigatingDelegate {
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }

    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
}

// MARK: GIDSignInDelegate
extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AuthService.shared.googleLogin(user: user, error: error) { (result) in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { (result) in
                    switch result {
                    case .success(let mUser):
                        UIApplication.getTopViewController()?.showAlert(with: "Успешно!", and: "Вы зарегистрированы!") {
                            let mainTabBar = MainTabBarController(currentUser: mUser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            UIApplication.getTopViewController()?.present(mainTabBar, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        UIApplication.getTopViewController()?.showAlert(with: "Успешно!", and: "Вы авторизированы!") {
                            UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user),
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
}

// MARK: SwiftUI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AuthViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) -> AuthViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: AuthViewController, context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
