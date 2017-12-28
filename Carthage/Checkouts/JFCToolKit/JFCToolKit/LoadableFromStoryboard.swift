import UIKit

/**
 Enables UIViewController subclasses to be loaded from a UIStoryboard programmatically by type rather then "magic strings".
 
 Usage Requirements:
 - Add conformance to UIViewController subclass. i.e. `extension SignInViewController: LoadableFromStoryboard`.
 - In Interface Builder set ViewController's Storyboard ID to name of subclass in identity inspector. i.e. `Storyboard ID: SignInViewController`.
 
 Conforming UIViewController subclasses can then be programatically instantiated from a UIStoryboard via included generic function. i.e.
 ```
 let signInVC = SignInViewController.loadFromStoryboard()
 ```
 */
public protocol LoadableFromStoryboard {
    static var storyboardFilename: String { get }
    static var storyboardIdentifier: String { get }
}

public extension LoadableFromStoryboard where Self: UIViewController {
    /// Defaults to name of type. i.e. `class SignInViewController: UIViewController` has a default storyboardIdentifier of `SignInViewController`.
    ///
    /// Set explicitly by implementing this property in conforming types.
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    /// See `LoadableFromStoryboard` protocol documentation.
    static func loadFromStoryboard(in bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: Self.storyboardFilename, bundle: bundle)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: Self.storyboardIdentifier)
        
        guard let viewControllerAsSelf = viewController as? Self else {
            fatalError("Attempted to load \(type(of: Self.self)) from storyboard \(Self.storyboardFilename) for identifier \(Self.storyboardIdentifier) but received incorrect type \(type(of: viewController))")
        }
        
        return viewControllerAsSelf
    }
}
