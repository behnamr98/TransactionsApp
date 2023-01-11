//
//  UICollectionView+EX.swift
//  RodiniaWallet
//
//  Created by Babak Afsheh on 2/24/21.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    func registerHeader<T: UICollectionReusableView>(_:T.Type) {
        register(UINib(nibName: String(describing: T.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        return cell
    }
    
}
