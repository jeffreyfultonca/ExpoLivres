import UIKit

// MARK: - UserInfoCoordinatorDelegate

protocol UserInfoCoordinatorDelegate: AnyObject {
    func userInfoCoordinatorDidFinish()
}

// MARK: - UserInfoCoordinator

class UserInfoCoordinator {
    
    // MARK: - Stored Properties
    
    private let providers: Providers
    private let userInfoViewController: UserInfoViewController
    weak var delegate: UserInfoCoordinatorDelegate?
    
    // MARK: - Lifecycle
    
    init(
        providers: Providers,
        userInfoViewController: UserInfoViewController,
        delegate: UserInfoCoordinatorDelegate)
    {
        self.providers = providers
        self.userInfoViewController = userInfoViewController
        self.delegate = delegate
    }
    
    func start() {
        userInfoViewController.delegate = self
        updateUI()
    }
    
    // MARK: - Update
    
    private func updateUI() {
        let viewData = UserInfoViewData(
            languageProvider: providers.languageProvider,
            userProvider: providers.userProvider
        )
        
        userInfoViewController.update(with: viewData)
    }
}

// MARK: - UserInfoViewControllerDelegate

extension UserInfoCoordinator: UserInfoViewControllerDelegate {
    func userInfoViewController(
        _ userInfoViewController: UserInfoViewController,
        didSelectLanguage language: Language)
    {
        providers.languageProvider.set(language: language)
        updateUI()
    }
    
    func didUpdateUserInfo(userInfoViewController: UserInfoViewController) {
        let user = User(
            organization: userInfoViewController.organization,
            purchaseOrder: userInfoViewController.purchaseOrder,
            name: userInfoViewController.name,
            email: userInfoViewController.email
        )
        providers.userProvider.set(user: user)
        updateUI()
    }
    
    func didSelectOK(userInfoViewController: UserInfoViewController) {
        guard providers.userProvider.user.isValid else {
            // TODO: Handle as error? This case should not be possible as long as the view prohibits pressing OK while insufficient data is provided.
            print("Unable to dismiss UserInfo screen while insufficient user info provided.")
            return
        }
        delegate?.userInfoCoordinatorDidFinish()
    }
}
