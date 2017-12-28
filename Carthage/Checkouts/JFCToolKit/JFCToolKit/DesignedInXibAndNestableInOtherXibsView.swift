import UIKit

/**
 UIView subclass conforming to DesignedInXibAndNestableInOtherXibsViewProtocol. 
 
 Use as a convenience base class when implementing `DesignedInXibAndNestableInOtherXibsViewProtocol`. 
 
 - Note: This class is not necessary as `UIView` subclasses can implement `DesignedInXibAndNestableInOtherXibsViewProtocol conformance directly. Using this as base class just reduces boiler plate code.
 */
open class DesignedInXibAndNestableInOtherXibsView: UIView, DesignedInXibAndNestableInOtherXibsViewProtocol {
    
    // MARK: - Stored Properties
    
    public var viewFromXib: UIView!
    
    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewFromXib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViewFromXib()
    }
}
