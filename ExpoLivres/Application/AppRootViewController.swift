import UIKit

/// UIViewController subclass used as root view controller for entire Application which forwards StatusBar style/hidden queries to first childViewController.
///
/// Used to conditionally show/dismiss Onboarding screens then reveal an ARSceneView underneath even though the ARSceneView was not actually loaded previously while still allowing childViewControllers to determine StatusBar settings.
class AppRootViewController: UIViewController {
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.first
    }
    
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return childViewControllers.first
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return childViewControllers.first?.supportedInterfaceOrientations ?? .all
    }
    
    override var shouldAutorotate: Bool {
        return childViewControllers.first?.shouldAutorotate ?? true
    }
    
    // MARK: - Transitions
    
    fileprivate var currentChildVC: UIViewController? {
        willSet {
            guard newValue == nil else { return }
            currentChildVC?.view.removeFromSuperview()
            currentChildVC?.removeFromParentViewController()
        }
    }
    
    func transition(to toVC: UIViewController) {
        let fromVC = currentChildVC
        fromVC?.willMove(toParentViewController: nil)
        
        self.addChildViewController(toVC)
        toVC.view.frame = self.view.frame
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(toVC.view)
        
        toVC.didMove(toParentViewController: self)
        fromVC?.view.removeFromSuperview()
        fromVC?.removeFromParentViewController()
        
        currentChildVC = toVC
    }
}

