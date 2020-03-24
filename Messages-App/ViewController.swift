//
//  ViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 24.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.gray
    }
}

//Добавляем реализацию отображения нашего View через Canvas (alt+cmd+P, refresh combination)
import SwiftUI

struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        //добавляем к нашему контейнеру метод игнорирования SafeArea, для адекватного, красивого, отображения
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let viewController = ViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerProvider.ContainerView>) -> ViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<ViewControllerProvider.ContainerView>) {
        }
        // swiftlint:enable line_lenght
    }
}
