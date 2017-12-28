import UIKit
import MessageUI

// MARK: - ListCoordinatorDelegate

protocol ListCoordinatorDelegate: AnyObject {
    // TODO: Implement.
}

// MARK: - ListCoordinator

class ListCoordinator: NSObject {
    
    // MARK: - Stored Properties
    
    private let providers: Providers
    private let listViewController: ListViewController
    weak var delegate: ListCoordinatorDelegate?
    
    // MARK: - Child Coordinators
    
    private var userInfoCoordinator: UserInfoCoordinator?
    
    // MARK: - Lifecycle
    
    init(
        providers: Providers,
        listViewController: ListViewController,
        delegate: ListCoordinatorDelegate? = nil)
    {
        self.providers = providers
        self.listViewController = listViewController
        self.delegate = delegate
    }
    
    func start() {
        listViewController.delegate = self
        updateUI(tableUpdateOption: .noUpdate)
    }
    
    // MARK: - Presentation
    
    private func showUserInfo() {
        let userInfoViewController = UserInfoViewController.loadFromStoryboard()
        
        userInfoCoordinator = UserInfoCoordinator(
            providers: providers,
            userInfoViewController: userInfoViewController,
            delegate: self
        )
        userInfoCoordinator?.start()
        
        listViewController.present(
            UINavigationController(rootViewController: userInfoViewController),
            animated: true
        )
    }
    
    private func dismissUserInfo(animated: Bool, completion: (() -> Void)? = nil) {
        listViewController.dismiss(animated: animated, completion: completion)
    }
    
    private func showScanner() {
        let scannerViewController = ScannerViewController.loadFromStoryboard()
        scannerViewController.delegate = self
        
        let viewData = ScannerViewData(
            cancelButtonTitle: providers.languageProvider.cancel
        )
        scannerViewController.update(with: viewData)
        
        listViewController.present(scannerViewController, animated: true)
    }
    
    private func dismissScanner(animated: Bool, completion: (() -> Void)? = nil ) {
        listViewController.dismiss(animated: animated, completion: completion)
    }
    
    private func showEmailNotConfiguredAlert() {
        let alertController = UIAlertController(
            title: providers.languageProvider.emailNotConfiguredTitle,
            message: providers.languageProvider.emailNotConfiguredMessage,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: providers.languageProvider.save, style: .default)
        alertController.addAction(okAction)
        
        listViewController.present(alertController, animated: true)
    }
    
    private func showComposeEmail() {
        let emailProvider = providers.emailProvider
        
        guard let attachmentData = emailProvider.attachmentData else {
            // TODO: Handle error?
            print("Could not encode booklist as data for email attachment.")
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.navigationBar.tintColor = listViewController.navigationController?.navigationBar.tintColor
        
        mailComposeVC.setToRecipients(emailProvider.toRecipients)
        mailComposeVC.setCcRecipients(emailProvider.ccRecipients)
        mailComposeVC.setSubject(emailProvider.subject)
        mailComposeVC.setMessageBody(emailProvider.body, isHTML: false)
        mailComposeVC.addAttachmentData(
            attachmentData,
            mimeType: "text/plain",
            fileName: emailProvider.attachmentFilename
        )
        
        listViewController.present(mailComposeVC, animated: true) {
            // TODO: Attempt to replace with MFMailComposeViewController subclass with preferredStatusBarStyle overridden.
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        }
    }
    
    private func dismissComposeEmail(animated: Bool, completion: (() -> Void)? = nil) {
        listViewController.dismiss(animated: true, completion: completion)
    }
    
    private func showClearListPrompt() {
        let languageProvider = providers.languageProvider
        
        let alertController = UIAlertController(
            title: languageProvider.postSubmissionTitle,
            message: languageProvider.postSubmissionMessage,
            preferredStyle: .alert
        )
        
        let keepListAction = UIAlertAction(
            title: languageProvider.keepAction,
            style: .default
        )
        alertController.addAction(keepListAction)
        
        let clearListAction = UIAlertAction(
            title: languageProvider.clearAction,
            style: .default,
            handler: { _ in self.clearList() }
        )
        alertController.addAction(clearListAction)
        
        listViewController.present(alertController, animated: true)
    }
    
    // MARK: - Update
    
    private func updateUI(tableUpdateOption: ListViewController.TableUpdateOption) {
        let viewData = ListViewData(
            languageProvider: providers.languageProvider,
            listProvider: providers.listProvider
        )
        
        listViewController.update(with: viewData, tableUpdateOption: tableUpdateOption)
    }
    
    func clearList() {
        providers.listProvider.clearList()
        updateUI(tableUpdateOption: .reloadAllRows)
    }
}

// MARK: - ListViewControllerDelegate

extension ListCoordinator: ListViewControllerDelegate {
    func didSelectUserInfo(listViewController: ListViewController) {
        showUserInfo()
    }
    
    func listViewController(
        _ listViewController: ListViewController,
        didDeleteListItem listItem: ListItem)
    {
        providers.listProvider.remove(item: listItem)
        
        if providers.listProvider.items.isEmpty {
            updateUI(tableUpdateOption: .reloadAllRows)
        } else {
            // Animate removal of last item in list.
            updateUI(tableUpdateOption: .removeRow(listItem: listItem))
        }
    }
    
    func didSelectSubmit(listViewController: ListViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            showEmailNotConfiguredAlert()
            return
        }
        
        showComposeEmail()
    }
    
    func didSelectScan(listViewController: ListViewController) {
        showScanner()
    }
}

// MARK: - UserInfoViewControllerDelegate

extension ListCoordinator: UserInfoViewControllerDelegate {
    func userInfoViewController(
        _ userInfoViewController: UserInfoViewController,
        didSelectLanguage language: Language)
    {
        providers.languageProvider.set(language: language)
        updateUI(tableUpdateOption: .reloadAllRows)
    }
    
    func didUpdateUserInfo(userInfoViewController: UserInfoViewController) {
        let user = User(
            organization: userInfoViewController.organization,
            purchaseOrder: userInfoViewController.purchaseOrder,
            name: userInfoViewController.name,
            email: userInfoViewController.email
        )
        providers.userProvider.set(user: user)
    }
    
    func didSelectOK(userInfoViewController: UserInfoViewController) {
        dismissUserInfo(animated: true)
    }
}

// MARK: - UserInfoCoordinatorDelegate

extension ListCoordinator: UserInfoCoordinatorDelegate {
    func userInfoCoordinatorDidFinish() {
        updateUI(tableUpdateOption: .reloadAllRows)
        
        dismissUserInfo(animated: true) {
            self.userInfoCoordinator = nil
        }
    }
}

// MARK: - ScannerViewControllerDelegate

extension ListCoordinator: ScannerViewControllerDelegate {
    func scannerViewController(
        _ scannerViewController: ScannerViewController,
        didScanSku sku: String)
    {
        let libraryItem = providers.libraryProvider.item(withSku: sku) ?? LibraryItem(
            title: providers.languageProvider.unknown,
            sku: sku
        )
        
        let listItem = ListItem(uuid: UUID(), libraryItem: libraryItem)
        
        providers.listProvider.add(item: listItem)
        
        dismissScanner(animated: true) {
            if self.providers.listProvider.items.count == 1 {
                self.updateUI(tableUpdateOption: .reloadAllRows)
            } else {
                self.updateUI(tableUpdateOption: .appendItemRow)
            }
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension ListCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?)
    {
        dismissComposeEmail(animated: true) {
            switch result.rawValue {
            case MFMailComposeResult.sent.rawValue:
                self.showClearListPrompt()
                
            default:
                break
            }
        }
    }
    
}
