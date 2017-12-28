import UIKit

/**
 Type with static `xibFilename` property able to load corresponding xib/nib. 
 
 Extends UITableView with generic function `registerNib<T>(forClass: T.Type, in: Bundle?) where T: ReuseIdentifiable, T: NibLoadable` which enables easy registration of conforming types. i.e.
 
 ```
 tableView.registerNib(forClass: DetailsCell.self, bundle: nil)
 
 ```
 
 `xibFilename` defaults to name of type. i.e. `class DetailsCell: UIView` defaults to `DetailsCell`. Can be set explicitly by implementing `static var xibFilename: String` in conforming types.
 */
public protocol NibLoadable {
    static var xibFilename: String { get }
    static func nib(in bundle: Bundle?) -> UINib
}

public extension NibLoadable {
    /// Defaults to name of conforming type. i.e. `class DetailsCell: UIView` has a default xibFilename of `DetailsCell`.
    ///
    /// Set explicitly by implementing this property in conforming types.
    public static var xibFilename: String {
        return String(describing: self)
    }
    
    /// Returns UINib initialized with `xibFilename` property.
    public static func nib(in bundle: Bundle?) -> UINib {
        return UINib(nibName: xibFilename, bundle: bundle)
    }
}

// MARK: - UITableView Extension

public extension UITableView {
    /// Register Nib for inferred type with type's reuseIdentifier.
    public func registerNib<T>(
        forClass reuseIdentifiableClass: T.Type,
        bundle: Bundle?) where T: ReuseIdentifiable, T: NibLoadable
    {
        let nib = reuseIdentifiableClass.nib(in: bundle)
        let reuseIdentifier = reuseIdentifiableClass.reuseIdentifier
        
        self.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UICollectionView Extension

public extension UICollectionView {
    /// Register Nib for inferred type with type's reuseIdentifier.
    public func registerNib<T>(
        forClass reuseIdentifiableClass: T.Type,
        bundle: Bundle?) where T: ReuseIdentifiable, T: NibLoadable
    {
        let nib = reuseIdentifiableClass.nib(in: bundle)
        let reuseIdentifier = reuseIdentifiableClass.reuseIdentifier
        
        self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
