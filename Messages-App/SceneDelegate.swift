//
//  SceneDelegate.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 24.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
//        myTestSignOut()
        if let user = Auth.auth().currentUser {
            FirestoreService.shared.getUserData(user: user) { (result) in
                switch result {
                case .success(let mUser):
                    let mainTabBar = MainTabBarController(currentUser: mUser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = mainTabBar
                case .failure(let error):
                    print("[Error] \(#function), \(error.localizedDescription)")
                    self.window?.rootViewController = AuthViewController()
                }
            }
        } else {
            window?.rootViewController = AuthViewController()
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    private func myTestSignOut() {
        do {
            try Auth.auth().signOut()
            UIWindow.key?.rootViewController = AuthViewController()
            //                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
        } catch {
            print("[Error] sign out problem \(error.localizedDescription)")
        }
    }
}
