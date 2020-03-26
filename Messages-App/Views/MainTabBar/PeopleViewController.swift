//
//  PeopleViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 25.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        setupSearchBar()
    }

    private func setupSearchBar() {
          navigationController?.navigationBar.barTintColor = .mainWhite()
          navigationController?.navigationBar.shadowImage = UIImage()
          let searchController = UISearchController(searchResultsController: nil)
          navigationItem.searchController = searchController
          navigationItem.hidesSearchBarWhenScrolling = false
          searchController.hidesNavigationBarDuringPresentation = false
          searchController.obscuresBackgroundDuringPresentation = false
          searchController.searchBar.delegate = self
      }
}

// MARK: UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: SwiftUI
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: PeopleVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_lenght
    }
}
