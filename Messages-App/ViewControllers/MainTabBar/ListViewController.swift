//
//  ListViewController.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 25.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
class ListViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case waitingChats, activeChats

        func description() -> String {
            switch self {
            case .waitingChats:
                return "Wating chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }

    let activeChats = Bundle.main.decode([MChat].self, from: "activeChats.json")
    let waitingChats = Bundle.main.decode([MChat].self, from: "waitingChats.json")

    // MARK: Init Collection View
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        return collectionView
    }()

    // MARK: Init Data Source
    //swiftlint:disable line_length
    lazy var dataSource: UICollectionViewDiffableDataSource<Section, MChat> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (_ collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                assertionFailure("[Error] Unknown section kind")
                return UICollectionViewCell()
            }
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView,
                                      cellType: ActiveChatCell.self,
                                      with: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView,
                                      cellType: WaitingChatCell.self,
                                      with: chat, for: indexPath)
            }
        })
        dataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                assertionFailure("[Error] Can not create new section header")
                return nil
            }

            guard let section = Section(rawValue: indexPath.section) else {
                assertionFailure("[Error] Unknown section kind")
                return nil
            }
            sectionHeader.configure(text: section.description(), font: .laoSangamMN20(), color: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))

            return sectionHeader
        }
        return dataSource
    }()
    //swiftlint:enable line_length

    private let currentUser: MUser

    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
//        title = currentUser.username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
        updateDataSource(with: nil)
        setupNavigationItem()
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
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseIdentifier)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseIdentifier)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
    }

    private func setupNavigationItem() {
        navigationItem.title = currentUser.username
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                               NSAttributedString.Key.font: UIFont.avenir20()]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes as [NSAttributedString.Key: Any]
    }
}

// MARK: Configure Data Source
extension ListViewController {

    private func updateDataSource(with searchText: String?) {
        let filteredWaitingChats = waitingChats.filter { (chat) -> Bool in
            chat.contains(filter: searchText)
        }
        let filteredActiveChats = activeChats.filter { (chat) -> Bool in
            chat.contains(filter: searchText)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(filteredActiveChats, toSection: .activeChats)
        snapshot.appendItems(filteredWaitingChats, toSection: .waitingChats)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Create Layout
extension ListViewController {

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _ layoutEnvironment)
            -> NSCollectionLayoutSection? in

            guard let section = Section(rawValue: sectionIndex) else {
                print("[Error] Unknown section kind")
                return nil
            }

            switch section {
            case .activeChats:
                return self.createActiveChatsLayout()
            case .waitingChats:
                return self.createWaitingChatsLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }

    private func createActiveChatsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func createWaitingChatsLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {

        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        // swiftlint:disable line_length
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        // swiftlint:enable line_length
        return sectionHeader
    }
}

// MARK: UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateDataSource(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateDataSource(with: nil)
    }
}

// MARK: SwiftUI
import SwiftUI

struct ListVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: ListVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
