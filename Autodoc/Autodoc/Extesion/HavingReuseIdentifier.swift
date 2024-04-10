//
//  HavingReuseIdentifier.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import Foundation
import UIKit
protocol HavingReuseIdentifier {
    static var reuseIdentifier: String { get }
}

extension HavingReuseIdentifier {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UITableViewCell: HavingReuseIdentifier {}
extension UICollectionReusableView: HavingReuseIdentifier {}

extension UITableView {
    func registerNibCell(of type: (some UITableViewCell & HavingReuseIdentifier).Type) {
        register(UINib(nibName: type.reuseIdentifier, bundle: nil), forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerCell(of type: (some UITableViewCell & HavingReuseIdentifier).Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerHeaderFooterNibView(of type: (some UITableViewHeaderFooterView & HavingReuseIdentifier).Type) {
        register(UINib(nibName: type.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerHeaderFooterView(of type: (some UITableViewHeaderFooterView & HavingReuseIdentifier).Type) {
        register(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell & HavingReuseIdentifier>(of type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView & HavingReuseIdentifier>(of type: T.Type) -> T {
        dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as! T
    }
}

extension UICollectionView {
    func registerNibCell(of type: (some UICollectionViewCell & HavingReuseIdentifier).Type) {
        register(UINib(nibName: type.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerCell(of type: (some UICollectionViewCell & HavingReuseIdentifier).Type) {
        register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerHeaderNibView(of type: (some UICollectionReusableView & HavingReuseIdentifier).Type) {
        let kind = UICollectionView.elementKindSectionHeader
        register(UINib(nibName: type.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerHeaderView(of type: (some UICollectionReusableView & HavingReuseIdentifier).Type) {
        register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerFooterNibView(of type: (some UICollectionReusableView & HavingReuseIdentifier).Type) {
        let kind = UICollectionView.elementKindSectionFooter
        register(UINib(nibName: type.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerFooterView(of type: (some UICollectionReusableView & HavingReuseIdentifier).Type) {
        register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerSupplimentaryNibView(of type: (some UICollectionReusableView & HavingReuseIdentifier).Type) {
        register(
            UINib(nibName: type.reuseIdentifier, bundle: nil),
            forSupplementaryViewOfKind: type.reuseIdentifier,
            withReuseIdentifier: type.reuseIdentifier
        )
    }
    
    func registerSupplimentaryView(of type: (some UICollectionReusableView & HavingReuseIdentifier).Type) {
        register(type, forSupplementaryViewOfKind: type.reuseIdentifier, withReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueCell<T: UICollectionViewCell & HavingReuseIdentifier>(of type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueHeaderView<T: UICollectionReusableView & HavingReuseIdentifier>(of type: T.Type, for indexPath: IndexPath) -> T {
        let kind = UICollectionView.elementKindSectionHeader
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueFooterView<T: UICollectionReusableView & HavingReuseIdentifier>(of type: T.Type, for indexPath: IndexPath) -> T {
        let kind = UICollectionView.elementKindSectionFooter
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueSupplimentaryView<T: UICollectionReusableView & HavingReuseIdentifier>(of type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: type.reuseIdentifier, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
}

