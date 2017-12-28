import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Stored Properties
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    // MARK: - Lifecycle
    
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(mainApplicationWindow: window!)
        appCoordinator!.start()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        appCoordinator?.applicationDidBecomeActive()
    }
}

