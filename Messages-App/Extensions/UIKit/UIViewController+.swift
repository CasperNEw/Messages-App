//
//  UIViewController+.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 27.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIViewController {

    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView,
                                                        cellType: T.Type, with value: U,
                                                        for indexPath: IndexPath) -> T {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier,
                                                             for: indexPath) as? T else {
                                                                 fatalError("Unable to dequeue \(cellType)")
         }
         cell.configure(with: value)
         return cell
     }
}
