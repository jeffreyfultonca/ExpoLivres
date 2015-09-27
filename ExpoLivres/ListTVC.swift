//
//  ListTVC.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-09.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit
import MessageUI

class ListTVC: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    ScannerVCDelegate,
    MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitLabel: UILabel!
    
    @IBOutlet weak var scanLabel: UILabel!
    
    var scannedBooks = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 74.5
        
        self.updateUIForLanguage()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateUIForLanguage",
            name: GlobalConstants.Notification.LanguageChanged,
            object: nil
        )
        
        self.loadStoredList()
        self.updateSubmitButtonState()
    }
    
    override func viewDidAppear(animated: Bool) {
        if UserInfoService.isNotValid {
            self.performSegueWithIdentifier("showUserInfo", sender: self)
        }
    }
    
    deinit {
        print("ListTVC.deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Helpers
    
    func updateUIForLanguage() {
        self.navigationItem.title = LanguageService.listTitle
        
        self.submitLabel.text = LanguageService.submit
        self.scanLabel.text = LanguageService.scan
        
        self.tableView.reloadData()
    }
    
    func loadStoredList() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let storedSkuList = defaults.objectForKey(GlobalConstants.UserDefaultsKey.storedSkuList) as? [String] ?? [String]()
        let context = PersistenceController.mainContext
        for sku in storedSkuList {
            if let book = Book.withSku(sku, inContext: context) {
                self.scannedBooks.append(book)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    func addToList(book: Book) {
        self.scannedBooks.append(book)
        LocalStorageService.addToList(book)
        
        self.updateSubmitButtonState()
    }
    
    func removeFromListAtIndex(index: Int) {
        self.scannedBooks.removeAtIndex(index)
        LocalStorageService.removeFromListAtIndex(index)
        
        self.updateSubmitButtonState()
    }
    
    func clearList() {
        self.scannedBooks.removeAll(keepCapacity: false)
        LocalStorageService.clearList()
        self.tableView.reloadData()
        self.updateSubmitButtonState()
    }
    
    func updateSubmitButtonState() {
        if scannedBooks.isEmpty {
            self.submitButton.enabled = false
            self.submitLabel.alpha = 0.3
        } else {
            self.submitButton.enabled = true
            self.submitLabel.alpha = 1.0
        }
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scannedBooks.isEmpty {
            return 1 // No items message
            
        } else {
            return scannedBooks.count + 1 // Add for SwipeMessage Cell
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if scannedBooks.isEmpty { // No items message
            let cell = tableView.dequeueReusableCellWithIdentifier("emptyListCell", forIndexPath: indexPath) as! EmptyListCell
            
            cell.headingLabel.text = LanguageService.listEmptyHeading
            cell.messageOneLabel.text = LanguageService.listBodyScan
            cell.messageTwoLabel.text = LanguageService.listBodySubmit
            
            return cell
            
        } else if indexPath.row == scannedBooks.count { // Swipe left message
            let cell = tableView.dequeueReusableCellWithIdentifier("swipeMessageCell", forIndexPath: indexPath) as! SwipeMessageCell
            
            cell.messageLabel.text = LanguageService.listSwipeMessage
            
            return cell
            
        } else { // Item
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
            
            let book = scannedBooks[indexPath.row]
            
            cell.titleLabel.text = book.title
            cell.isbnLabel.text = "isbn: \(book.sku)"
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if scannedBooks.isEmpty {
            return tableView.bounds.height - tableView.contentInset.top
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row != scannedBooks.count
    }

    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.removeFromListAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Reload first row to display No items message
            if scannedBooks.isEmpty {
                let noItemsIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                tableView.reloadRowsAtIndexPaths([noItemsIndexPath] , withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return LanguageService.remove
    }

    // MARK: - Actions
    
    @IBAction func userInfoPressed(sender: AnyObject) {
        performSegueWithIdentifier("showUserInfo", sender: sender)
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        print("submitPressed")
        
        if MFMailComposeViewController.canSendMail() {
            
            // Create Sku text file
            var isbnString = "ISBN\n"
            
            for book in self.scannedBooks {
                isbnString += "\(book.sku)\n"
            }
            
            // Create MailComposeVC and attach file
            
            if let isbnStringAsData = isbnString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
                
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                mailComposeVC.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
                
                mailComposeVC.setToRecipients([ GlobalConstants.email.toRecipient ])
                
                if let email = LocalStorageService.email {
                    mailComposeVC.setCcRecipients([ email ])
                }
                
                mailComposeVC.setSubject( GlobalConstants.email.subject )
                mailComposeVC.setMessageBody(GlobalConstants.email.body, isHTML: false)
                mailComposeVC.addAttachmentData(isbnStringAsData, mimeType: "text/plain", fileName: GlobalConstants.email.attachedFileName)
                
                self.navigationController!.presentViewController(mailComposeVC, animated: true, completion: {
                    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
                })
            } else {
                print("Could not encode booklist as data for email attachment.")
            }
        } else {
            let alertController = UIAlertController(
                title: LanguageService.emailNotConfiguredTitle,
                message: LanguageService.emailNotConfiguredMessage,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            let okAction = UIAlertAction(title: LanguageService.save, style: .Default, handler: nil)
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - MFMailCompose Delegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        self.dismissViewControllerAnimated(true, completion: {
            switch result.rawValue {
            case MFMailComposeResultCancelled.rawValue:
                print("Cancelled")
            case MFMailComposeResultFailed.rawValue:
                print("Failed")
            case MFMailComposeResultSaved.rawValue:
                print("Saved")
            case MFMailComposeResultSent.rawValue:
                print("Sent")
                
                // Ask to clear list
                let alertController = UIAlertController(
                    title: LanguageService.postSubmissionTitle,
                    message: LanguageService.postSubmissionMessage,
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                let keepListAction = UIAlertAction(title: LanguageService.keepAction, style: .Default, handler: nil)
                let clearListAction = UIAlertAction(title: LanguageService.clearAction, style: .Default, handler: { alertAction in
                    self.clearList()
                })
                
                alertController.addAction(keepListAction)
                alertController.addAction(clearListAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            default:
                print("Unknown result")
            }
        })
    }
    
    // MARK: - Scanner Delegate
    
    func scannerSuccessfullyScannedSku(sku: String) {
        
        self.dismissViewControllerAnimated(true) {
            let context = PersistenceController.mainContext
            if let scannedBook = Book.withSku(sku, inContext: context) {
                self.addToList(scannedBook)
                
                let newItemIndexPath = NSIndexPath(forRow: self.scannedBooks.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([newItemIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                let lastIndexPath = NSIndexPath(forRow: self.scannedBooks.count, inSection: 0)
                if self.scannedBooks.count == 1 {
                    self.tableView.reloadRowsAtIndexPaths([lastIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                self.tableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                
            } else {
                let alertController = UIAlertController(
                    title: LanguageService.scanNotFoundTitle,
                    message: LanguageService.scanNotFoundMessage(sku),
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                let okAction = UIAlertAction(title: LanguageService.save, style: .Default, handler: nil)
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showScanner" {
            let scannerVC = segue.destinationViewController as! ScannerVC
            scannerVC.delegate = self
        }
    }
}
