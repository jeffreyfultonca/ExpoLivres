import UIKit

/**
 Enables easy, safe embedding of child view controllers inside conforming UIViewContoller subclasses.
 
 **Usage**
 
 1. Define the associated `ChildViewControllerContainer` type as an enum with a `String` raw value nested inside the conforming type. Each case corresponds to a container `UIView` which will hold child view controllers:
 
     ```
     class ViewController: ChildViewControllerEmbeddable {
         enum ChildViewControllerContainer: String {
             case map
             case table
         }
     }
     ```
 
 2. Add `embeddedChildVCs` property to conforming type:
    ```
    var embeddedChildVCs: [ChildViewControllerContainer: UIViewController] = [:]
    ```
 
 3. Implement `containerView(for container:) -> UIView` on conforming type mapping each enum case to a corresponding container view:
    
    ```
     func containerView(
         for container: ChildViewControllerContainer) -> UIView
     {
         switch container {
         case .main: return self.mainContainerView
         case .lower: return self.lowerContainerView
         }
     }
    ```
 */
public protocol ChildViewControllerEmbeddable: class {
    associatedtype ChildViewControllerContainer: Hashable
    
    var embeddedChildVCs: [ChildViewControllerContainer: UIViewController] { get set }
    
    func containerView(
        for container: ChildViewControllerContainer
    ) -> UIView
    
    func embed(
        childViewController childVC: UIViewController,
        inContainer container: ChildViewControllerContainer
    )
    
    func childViewController(
        for container: ChildViewControllerContainer
    ) -> UIViewController?
    
    func removeChildViewControler(
        fromContainer container: ChildViewControllerContainer
    )
}

public extension ChildViewControllerEmbeddable where Self: UIViewController {
    public func embed(
        childViewController childVC: UIViewController,
        inContainer container: ChildViewControllerContainer)
    {
        self.removeChildViewControler(fromContainer: container)
        
        let containerView = self.containerView(for: container)
        
        childVC.willMove(toParentViewController: self)
        childVC.view.willMove(toSuperview: containerView)
        
        self.addChildViewController(childVC)
        containerView.addSubview(childVC.view)
        
        embeddedChildVCs[container] = childVC
        
        childVC.view.frame = containerView.bounds
        
        childVC.didMove(toParentViewController: self)
        childVC.view.didMoveToSuperview()
    }
    
    public func childViewController(
        for container: ChildViewControllerContainer) -> UIViewController?
    {
        return embeddedChildVCs[container]
    }
    
    public func removeChildViewControler(fromContainer container: ChildViewControllerContainer) {
        guard let childVC = childViewController(for: container) else { return }
        
        childVC.view.willMove(toSuperview: nil)
        childVC.willMove(toParentViewController: nil)
        
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
        
        embeddedChildVCs[container] = nil
    }
}
