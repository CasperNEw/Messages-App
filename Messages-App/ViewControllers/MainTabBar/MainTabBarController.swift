//
//  MainTabBarController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 25.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let currentUser: MUser

    init(currentUser: MUser = MUser(userId: "Special", username: "entity",
                                    email: "for", avatarPath: "SwiftUI",
                                    description: "canvas", sex: "view")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let listVuewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)

        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        guard let peopleImage = UIImage(systemName: "person.2",
                                        withConfiguration: boldConfig),
            let convImage = UIImage(systemName: "bubble.left.and.bubble.right",
                                    withConfiguration: boldConfig) else { return }

//        viewControllers = [generateNavigationController(rootVC: listVuewController,
//                                                        title: "Conversation", image: convImage),
//                           generateNavigationController(rootVC: peopleViewController,
//                                                        title: "People", image: peopleImage)]
        viewControllers = [generateNavigationController(rootVC: peopleViewController,
                                                        title: "People", image: peopleImage),
                           generateNavigationController(rootVC: listVuewController,
                                                        title: "Conversation", image: convImage)]
    }

    private func generateNavigationController(rootVC: UIViewController,
                                              title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
