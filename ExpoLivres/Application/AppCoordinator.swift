import UIKit

class AppCoordinator {
   
    // MARK: - Stored Properties
    
    private let applicationWindow: UIWindow
    private let providers = Providers.forCurrentConfiguration()
    
    // MARK: - Child Coordinators
    
//    private var pregnancyDatesCoordinator: PregnancyDatesCoordinator?
    
    // MARK: - Lifecycle
    
    init(applicationWindow: UIWindow) {
        self.applicationWindow = applicationWindow
    }
    
    func start() {
        providers.migrationProvider.performMigrationIfRequired()
        setupAppWideNavBarAppearance()

        // TODO: Conditionally load screens.
        // Show list if valid user info already provided
        // Otherwise show landing screen, which then presents userInfo, which dismisses to reveal list.
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
    
    private func showUserInfo() {
        // TODO: Implement.
    }
    
    private func showList() {
        // TODO: Implement.
//        let pregnancyDatesViewController = PregnancyDatesViewController.loadFromStoryboard()
//
//        pregnancyDatesCoordinator = PregnancyDatesCoordinator(
//            providers: providers,
//            pregnancyDatesViewController: pregnancyDatesViewController
//        )
//        pregnancyDatesCoordinator?.start()
//
//        applicationWindow.rootViewController = pregnancyDatesViewController
//        applicationWindow.makeKeyAndVisible()
    }
}
