import UIKit

/**
 Type with static `reuseIdentifier` property used by containing types for view reuse. i.e. UITableView, UICollectionView.
 
 `reuseIdentifier` defaults to name of type. i.e. `class DetailsCell: UIView` defaults to `DetailsCell`. Can be set explicitly by implementing `static var reuseIdentifier: String` in conforming types.
 
 */
public protocol ReuseIdentifiable: class {
    static var reuseIdentifier: String { get }
}

public extension ReuseIdentifiable {
    /// Defaults to name of type. i.e. `class DetailsCell: UIView` has a default reuseIdentifier of `DetailsCell`.
    ///
    /// Set explicitly by implementing this property in conforming types.
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UITableView {
    /// Register reusable cell of inferred type with type's reuseIdentifier.
    public func register<T: ReuseIdentifiable>(reuseIdentifiableClass: T.Type) {
        self.register(reuseIdentifiableClass, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Dequeues reusable cell of inferred type with type's reuseIdentifier.
    /// 
    /// - Note `fatalError` occurs if cell type has not been registered with tableView.
    public func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        file: StaticString = #file,
        line: UInt = #line) -> T where T: ReuseIdentifiable
    {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.reuseIdentifier,
            for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with reuseIdentifier -- \(T.reuseIdentifier) --",
                file: file,
                line: line
            )
        }
        
        return cell
    }
}

public extension UICollectionView {
    /// Register reusable cell of inferred type with type's reuseIdentifier.
    public func register<T: ReuseIdentifiable>(reuseIdentifiableClass: T.Type) {
        self.register(reuseIdentifiableClass, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Dequeues reusable cell of inferred type with type's reuseIdentifier.
    ///
    /// - Note `fatalError` occurs if cell type has not been registered with tableView.
    public func dequeueReusableCell<T: UICollectionViewCell>(
        for indexPath: IndexPath,
        file: StaticString = #file,
        line: UInt = #line) -> T where T: ReuseIdentifiable
    {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with reuseIdentifier -- \(T.reuseIdentifier) --",
                file: file,
                line: line
            )
        }
        
        return cell
    }
}
