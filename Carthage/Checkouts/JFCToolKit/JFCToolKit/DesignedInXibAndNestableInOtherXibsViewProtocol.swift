import UIKit

// MARK: -

/**
 Allows conforming UIView subclass to load views designed in Xib file. Views are then "Designable" via the `@IBDesignable` attribute and will render in Storyboards and other Xib files.
 
 Usage Requirements:
 1. Conforming types must be accompanied by Xib file. Xib's filename defaults to name of conforming type. i.e. `class DesignedInXibView` and `DesignedInXibView.xib`. Xib filename can be set explicitly by implementing the `xibFilename` property.
 2. `File's Owner Class:` in IB must be set to conforming class. i.e. `File's Owner Class: DesignedInXibView`.
 3. Conforming type declaration must be marked with `@IBDesignable` attribute. i.e. `@IBDesignable class DesignedInXibView`.
 4. All `init` functions of confroming type must call `setupViewFromXib()`.
 */
public protocol DesignedInXibAndNestableInOtherXibsViewProtocol: class {
    var xibFilename: String { get }
    var viewFromXib: UIView! { get set }
}

// MARK: - 

public extension DesignedInXibAndNestableInOtherXibsViewProtocol where Self: UIView {
    /// Filename of corresponding Xib. Defaults to name of conforming type. i.e. `class DesignedInXibView` and `DesignedInXibView.xib`. Set explicitly by implementing this property in conforming types.
    public var xibFilename: String {
        return String(describing: type(of: self))
    }
    
    public func setupViewFromXib() {
        // Instantiate view designed in .xib
        viewFromXib = instantiateViewFromXib()
        
        // Add viewFromXib to actual view at base of hierarchy so other views from Storyboard/Xib will appear on top.
        self.insertSubview(viewFromXib, at: 0)
        
        // Add layout constraints so the viewFromXib always fills the actual view.
        viewFromXib.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewFromXib.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewFromXib.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewFromXib.topAnchor.constraint(equalTo: self.topAnchor),
            viewFromXib.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func instantiateViewFromXib() -> UIView {
        // Note: The bundle for this class must be specified! We often pass in nil for the bundle argument assuming that the main bundle will work. However passing in nil here will result in IB's layout engine crashing because apparently it does not use the main bundle... or something?
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibFilename, bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
