//
//  Reusable.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit

// MARK: - NibLoadable

protocol NibLoadable: class {
	static var nib: UINib { get }
}

extension NibLoadable {
	static var nib: UINib {
		return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
	}
}

extension NibLoadable where Self: UIView {
	static func loadFromNib() -> Self {
		return nib.instantiate(withOwner: nil, options: nil).first as! Self
	}
}

// MARK: - Reusable

protocol Reusable {
	static var reuseIdentifier: String { get }
}

extension Reusable {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

// MARK: - UITableView

extension UITableView {
	
	final func register<T: UITableViewCell>(type: T.Type) where T: Reusable & NibLoadable {
		register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
	}
	
	final func register<T: UITableViewCell>(type: T.Type) where T: Reusable {
		register(type, forCellReuseIdentifier: type.reuseIdentifier)
	}
	
	final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, type: T.Type = T.self) -> T where T: Reusable {
		return dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
	}
	
	final func register<T: UITableViewHeaderFooterView>(type: T.Type) where T: Reusable & NibLoadable {
		register(type.nib, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
	}
	
	final func register<T: UITableViewHeaderFooterView>(type: T.Type) where T: Reusable {
		register(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
	}
	
	final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type = T.self) -> T? where T: Reusable {
		return dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? T
	}
	
}


// MARK: - UICollectionView

extension UICollectionView {
	
	final func register<T: UICollectionViewCell>(type: T.Type) where T: Reusable & NibLoadable {
		register(type.nib, forCellWithReuseIdentifier: type.reuseIdentifier)
	}
	
	final func register<T: UICollectionViewCell>(type: T.Type) where T: Reusable {
		register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
	}
	
	final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, type: T.Type = T.self) -> T where T: Reusable {
		return dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
	}
	
	final func register<T: UICollectionReusableView>(type: T.Type, ofKind elementKind: String) where T: Reusable & NibLoadable {
		register(type.nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: type.reuseIdentifier)
	}
	
	final func register<T: UICollectionReusableView>(type: T.Type, ofKind elementKind: String) where T: Reusable {
		register(type.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: type.reuseIdentifier)
	}
	
	final func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath, type: T.Type = T.self) -> T where T: Reusable {
		return dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
	}
	
}

// MAKR: - StoryboardLoadable

protocol StoryboardLoadable {
	static var ownerStoryboard: UIStoryboard { get }
}

extension StoryboardLoadable where Self: UIViewController {
	
	static func instantiate() -> Self {
		return Self.ownerStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
	}
	
}

// MAKR: - StoryboardInitialLoadable

protocol StoryboardInitialLoadable {
	static var ownerStoryboard: UIStoryboard { get }
}

extension StoryboardInitialLoadable where Self: UIViewController {
	
	static func instantiate() -> (vc: UIViewController, oneself: Self?) {
		let initialVC = self.ownerStoryboard.instantiateInitialViewController()!
		
		switch initialVC {
		case let vc as Self:
			return (vc: initialVC, oneself: vc)
		case let vc as UINavigationController:
			return (vc: initialVC, oneself: vc.viewControllers.first as? Self)
		default:
			return (vc: initialVC, oneself: nil)
		}
	}
	
}
