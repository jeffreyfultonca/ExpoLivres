import UIKit

class AppCoordinator {
   
    // MARK: - Stored Properties
    
    private let mainApplicationWindow: UIWindow
    private let appRootViewController = AppRootViewController()
    private let providers = Providers.forCurrentConfiguration()
    
    // MARK: - Child Coordinators
    
    private var userInfoCoordinator: UserInfoCoordinator?
    private var listCoordinator: ListCoordinator?
    
    // MARK: - Lifecycle
    
    init(mainApplicationWindow: UIWindow) {
        self.mainApplicationWindow = mainApplicationWindow
    }
    
    func start() {
        // TODO: Remove at a future date once reasonably sure most users have migrated.
        performMigrationIfRequired()
        
        setupAppWideNavBarAppearance()
        
        self.mainApplicationWindow.rootViewController = appRootViewController
        mainApplicationWindow.makeKeyAndVisible()

        if providers.userProvider.user.isValid {
            showList()
        } else {
            showLandingScreen()
        }
    }
    
    // MARK: - Setup
    
    private func setupAppWideNavBarAppearance() {
        // TODO: Confirm this works this early in Application lifecycle.
        let navBarAppearance = UINavigationBar.appearance()
        
        guard let background = UIImage(named: "Navbar")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch) else { return }
        
        navBarAppearance.setBackgroundImage(background, for: .default)
        navBarAppearance.tintColor = .white
        navBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    // MARK: - Presentation
    
    private func showLandingScreen() {
        let landingViewController = LandingViewController.loadFromStoryboard()
        landingViewController.delegate = self
        
        appRootViewController.transition(to: landingViewController)
    }
    
    private func showUserInfo(animated: Bool) {
        let userInfoViewController = UserInfoViewController.loadFromStoryboard()
        
        userInfoCoordinator = UserInfoCoordinator(
            providers: providers,
            userInfoViewController: userInfoViewController,
            delegate: self
        )
        userInfoCoordinator?.start()
        
        appRootViewController.present(
            UINavigationController(rootViewController: userInfoViewController),
            animated: animated
        )
    }
    
    private func dismissUserInfo(animated: Bool, completion: (() -> Void)? ) {
        appRootViewController.dismiss(animated: animated, completion: completion)
    }
    
    private func showList() {
        let listViewController = ListViewController.loadFromStoryboard()
        
        listCoordinator = ListCoordinator(
            providers: providers,
            listViewController: listViewController,
            delegate: self
        )
        listCoordinator?.start()
        
        appRootViewController.transition(
            to: UINavigationController(rootViewController: listViewController)
        )
    }
    
    // MARK: - Update
    
    func applicationDidBecomeActive() {
        providers.libraryProvider.updateLocalCache()
    }

    // MARK: - Migration
    
    private func performMigrationIfRequired() {
        providers.languageProvider.performMigrationIfRequired()
        providers.userProvider.performMigrationIfRequired()
        providers.listProvider.performMigrationIfRequired()
        providers.libraryProvider.performMigrationIfRequired()
    }
}

// MARK: - LandingViewControllerDelegate

extension AppCoordinator: LandingViewControllerDelegate {
    func didSelectEnterApplicationInFrench() {
        providers.languageProvider.set(language: .french)
        showUserInfo(animated: true)
    }
    
    func didSelectEnterApplicationInEnglish() {
        providers.languageProvider.set(language: .english)
        showUserInfo(animated: true)
    }
}

// MARK: - UserInfoCoordinatorDelegate

extension AppCoordinator: UserInfoCoordinatorDelegate {
    func userInfoCoordinatorDidFinish() {
        // Transition to List screen while modal is still on top.
        showList()
        
        // Dismiss to reveal List screen.
        dismissUserInfo(animated: true) {
            self.userInfoCoordinator = nil
        }
    }
}

// MARK: - ListCoordinatorDelegate

extension AppCoordinator: ListCoordinatorDelegate {}
