import UIKit
import JFCToolKit

// MARK: - LandingViewControllerDelegate

protocol LandingViewControllerDelegate: AnyObject {
    func didSelectEnterApplicationInEnglish()
    func didSelectEnterApplicationInFrench()
}

// MARK: - LandingViewController

class LandingViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    weak var delegate: LandingViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - Actions
    
    @IBAction func enterApplicationInFrenchTapped(_ sender: AnyObject?) {
        delegate?.didSelectEnterApplicationInFrench()
    }
    
    @IBAction func enterApplicationInEnglishTapped(_ sender: AnyObject?) {
        delegate?.didSelectEnterApplicationInEnglish()
    }
}

// MARK: - LoadableFromStoryboard

extension LandingViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "Landing" }
}
