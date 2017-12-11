import UIKit
import MessageUI

class ListViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    ScannerVCDelegate,
    MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitLabel: UILabel!
    
    @IBOutlet weak var scanLabel: UILabel!
    
    var persistenceService = PersistenceService.sharedInstance
    var scannedBooks = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 74.5
        
        self.updateUIForLanguage()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUIForLanguage),
            name: NSNotification.Name(rawValue: GlobalConstants.Notification.LanguageChanged),
            object: nil
        )
        
        self.loadStoredList()
        self.updateSubmitButtonState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserInfoService.isNotValid {
            self.performSegue(withIdentifier: "showUserInfo", sender: self)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    @objc
    func updateUIForLanguage() {
        self.navigationItem.title = LanguageService.listTitle
        
        self.submitLabel.text = LanguageService.submit
        self.scanLabel.text = LanguageService.scan
        
        self.tableView.reloadData()
    }
    
    func loadStoredList() {
        let storedSkuList = PersistenceService.sharedInstance.storedSkuList
        let context = persistenceService.mainContext
        for sku in storedSkuList {
            if let book = Book.withSku(sku, inContext: context) {
                self.scannedBooks.append(book)
            } else {
                let book = Book.createWith(
                    title: LanguageService.unknown,
                    sku: sku,
                    inContext: context
                )
                persistenceService.saveContext(context)

                self.scannedBooks.append(book)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    func addToList(_ book: Book) {
        self.scannedBooks.append(book)
        PersistenceService.sharedInstance.addToSkuList(book.sku)
        
        self.updateSubmitButtonState()
    }
    
    func removeFromListAtIndex(_ index: Int) {
        self.scannedBooks.remove(at: index)
        PersistenceService.sharedInstance.removeFromListAtIndex(index)
        
        self.updateSubmitButtonState()
    }
    
    func clearList() {
        self.scannedBooks.removeAll(keepingCapacity: false)
        PersistenceService.sharedInstance.clearList()
        self.tableView.reloadData()
        self.updateSubmitButtonState()
    }
    
    func updateSubmitButtonState() {
        if scannedBooks.isEmpty {
            self.submitButton.isEnabled = false
            self.submitLabel.alpha = 0.3
        } else {
            self.submitButton.isEnabled = true
            self.submitLabel.alpha = 1.0
        }
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scannedBooks.isEmpty {
            return 1 // No items message
            
        } else {
            return scannedBooks.count + 1 // Add for SwipeMessage Cell
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if scannedBooks.isEmpty { // No items message
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyListCell", for: indexPath) as! EmptyListCell
            
            cell.headingLabel.text = LanguageService.listEmptyHeading
            cell.messageOneLabel.text = LanguageService.listBodyScan
            cell.messageTwoLabel.text = LanguageService.listBodySubmit
            
            return cell
            
        } else if indexPath.row == scannedBooks.count { // Swipe left message
            let cell = tableView.dequeueReusableCell(withIdentifier: "swipeMessageCell", for: indexPath) as! SwipeMessageCell
            
            cell.messageLabel.text = LanguageService.listSwipeMessage
            
            return cell
            
        } else { // Item
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
            
            let book = scannedBooks[indexPath.row]
            
            cell.titleLabel.text = book.title
            cell.isbnLabel.text = "isbn: \(book.sku)"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if scannedBooks.isEmpty {
            return tableView.bounds.height - tableView.contentInset.top
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != scannedBooks.count
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.removeFromListAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Reload first row to display No items message
            if scannedBooks.isEmpty {
                let noItemsIndexPath = IndexPath(row: 0, section: 0)
                tableView.reloadRows(at: [noItemsIndexPath] , with: UITableViewRowAnimation.fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return LanguageService.remove
    }

    // MARK: - Actions
    
    @IBAction func userInfoPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "showUserInfo", sender: sender)
    }
    
    @IBAction func submitPressed(_ sender: AnyObject) {
        print("submitPressed")
        
        if MFMailComposeViewController.canSendMail() {
            
            // Create Sku text file
            var isbnString = "ISBN\n"
            
            for book in self.scannedBooks {
                isbnString += "\(book.sku)\n"
            }
            
            // Create MailComposeVC and attach file
            
            if let isbnStringAsData = isbnString.data(using: String.Encoding.utf8, allowLossyConversion: true) {
                
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                mailComposeVC.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
                
                mailComposeVC.setToRecipients([ GlobalConstants.email.toRecipient ])
                
                if let email = PersistenceService.sharedInstance.userEmail {
                    mailComposeVC.setCcRecipients([ email ])
                }
                
                mailComposeVC.setSubject( GlobalConstants.email.subject )
                mailComposeVC.setMessageBody(GlobalConstants.email.body, isHTML: false)
                mailComposeVC.addAttachmentData(isbnStringAsData, mimeType: "text/plain", fileName: GlobalConstants.email.attachedFileName)
                
                self.navigationController!.present(mailComposeVC, animated: true, completion: {
                    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
                })
            } else {
                print("Could not encode booklist as data for email attachment.")
            }
        } else {
            let alertController = UIAlertController(
                title: LanguageService.emailNotConfiguredTitle,
                message: LanguageService.emailNotConfiguredMessage,
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let okAction = UIAlertAction(title: LanguageService.save, style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - MFMailCompose Delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: {
            switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:
                print("Cancelled")
            case MFMailComposeResult.failed.rawValue:
                print("Failed")
            case MFMailComposeResult.saved.rawValue:
                print("Saved")
            case MFMailComposeResult.sent.rawValue:
                print("Sent")
                
                // Ask to clear list
                let alertController = UIAlertController(
                    title: LanguageService.postSubmissionTitle,
                    message: LanguageService.postSubmissionMessage,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                
                let keepListAction = UIAlertAction(title: LanguageService.keepAction, style: .default, handler: nil)
                let clearListAction = UIAlertAction(title: LanguageService.clearAction, style: .default, handler: { alertAction in
                    self.clearList()
                })
                
                alertController.addAction(keepListAction)
                alertController.addAction(clearListAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            default:
                print("Unknown result")
            }
        })
    }
    
    // MARK: - Scanner Delegate
    
    func scannerSuccessfullyScannedSku(_ sku: String) {
        
        self.dismiss(animated: true) {
            let context = self.persistenceService.mainContext
            if let scannedBook = Book.withSku(sku, inContext: context) {
                self.addToList(scannedBook)
                
                let newItemIndexPath = IndexPath(row: self.scannedBooks.count - 1, section: 0)
                self.tableView.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.fade)
                
                let lastIndexPath = IndexPath(row: self.scannedBooks.count, section: 0)
                if self.scannedBooks.count == 1 {
                    self.tableView.reloadRows(at: [lastIndexPath], with: UITableViewRowAnimation.fade)
                }
                self.tableView.scrollToRow(at: lastIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                
            } else {
                let alertController = UIAlertController(
                    title: LanguageService.scanNotFoundTitle,
                    message: LanguageService.scanNotFoundMessage(sku),
                    preferredStyle: UIAlertControllerStyle.alert
                )
                
                let cancelAction = UIAlertAction(
                    title: LanguageService.cancel,
                    style: .default,
                    handler: nil
                )
                
                let addAnyAction = UIAlertAction(
                    title: LanguageService.addAnyway,
                    style: .default,
                    handler: { _ in
                        let unknownBook = Book.createWith(
                            title: LanguageService.unknown,
                            sku: sku,
                            inContext: context
                        )
                        PersistenceService.sharedInstance.saveContext(context)
                        
                        self.addToList(unknownBook)
                        
                        let newItemIndexPath = IndexPath(row: self.scannedBooks.count - 1, section: 0)
                        self.tableView.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.fade)
                        
                        let lastIndexPath = IndexPath(row: self.scannedBooks.count, section: 0)
                        if self.scannedBooks.count == 1 {
                            self.tableView.reloadRows(at: [lastIndexPath], with: UITableViewRowAnimation.fade)
                        }
                        self.tableView.scrollToRow(at: lastIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                    }
                )
                
                alertController.addAction(cancelAction)
                alertController.addAction(addAnyAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScanner" {
            let scannerVC = segue.destination as! ScannerVC
            scannerVC.delegate = self
        }
    }
}
