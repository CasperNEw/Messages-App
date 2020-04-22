//
//  PeopleViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 25.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case users

        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearbly"
            }
        }
    }

    var users = [MUser]()
    private var userListener: ListenerRegistration?

    // MARK: Init Collection View
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        return collectionView
    }()

    // MARK: Init Data Source
    // swiftlint:disable line_length
    lazy var dataSource: UICollectionViewDiffableDataSource<Section, MUser> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { (_ collectionView, indexPath, _ user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                assertionFailure("[Error] Unknown section kind")
                return UICollectionViewCell()
            }
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self,
                                      with: user, for: indexPath)
            }
        })
        return dataSource
    }()
    // swiftlint:enable line_length

    private let currentUser: MUser

    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        userListener?.remove()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
        setupNavigationItem()
        setupUserListener()
        setupSectionHeader()
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

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.delegate = self
    }

    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain,
                                                            target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = .gray
        if let font = UIFont.avenir20() {
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }

        navigationItem.title = currentUser.username
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                               NSAttributedString.Key.font: UIFont.avenir20()]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes as [NSAttributedString.Key: Any]
    }

    @objc func signOut() {
        let alertController = UIAlertController(title: nil, message: "Вы действительно хотите выйти?",
                                                preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let secondAction = UIAlertAction(title: "Выход", style: .destructive) { (_) in
            do {
                try Auth.auth().signOut()
                UIWindow.key?.rootViewController = AuthViewController()
            } catch {
                print("[Error] sign out problem \(error.localizedDescription)")
            }
        }
        alertController.view.tintColor = .gray
        secondAction.setValue(UIColor.buttonRed(), forKey: "titleTextColor")
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        present(alertController, animated: true)
    }

    private func setupUserListener() {
        userListener = ListenerService.shared.usersObeserve(users: users, completion: { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.updateDataSource(with: nil)
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        })
    }
}

// MARK: Configure Data Source
extension PeopleViewController {

    private func updateDataSource(with searchText: String?) {
        let filtered = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filtered, toSection: .users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupSectionHeader() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            // swiftlint:disable line_length
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                assertionFailure("[Error] Can not create new section header")
                return nil
            }
            // swiftlint:enable line_length
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            guard let section = Section(rawValue: indexPath.section) else {
                assertionFailure("[Error] Unknown section kind")
                return nil
            }
            sectionHeader.configure(text: section.description(usersCount: items.count),
                                    font: .systemFont(ofSize: 36, weight: .light),
                                    color: .label)

            return sectionHeader
        }
    }
}

// MARK: Create Layout
extension PeopleViewController {

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _ layoutEnvironment)
            -> NSCollectionLayoutSection? in

            guard let section = Section(rawValue: sectionIndex) else {
                print("[Error] Unknown section kind")
                return nil
            }

            switch section {
            case .users:
                return self.createUsersLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }

    private func createUsersLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {

        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        return sectionHeader
    }
}

// MARK: UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateDataSource(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateDataSource(with: nil)
    }
}

// MARK: UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true)
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
        // swiftlint:enable line_length
    }
}
