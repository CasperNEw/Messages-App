//
//  UIApplication+.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 06.04.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
