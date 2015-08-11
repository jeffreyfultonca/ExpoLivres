//
//  ListTVC.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-09.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

struct ListItem {
    var title: String
    var isbn: String
}

class ListTVC: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var listItems = [ListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 74.5
        
        // Sample items
        listItems.append(ListItem(title: "Sample Items Title", isbn: "123-456-789A") )
        listItems.append(ListItem(title: "Sample Items Title", isbn: "123-456-789A") )
        listItems.append(ListItem(title: "Sample Items Title", isbn: "123-456-789A") )
    }
    
    override func viewDidAppear(animated: Bool) {
        if UserInfo.isNotValid {
            self.performSegueWithIdentifier("showUserInfo", sender: self)
        }
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listItems.isEmpty {
            return 1 // No items message
            
        } else {
            return listItems.count + 1 // Add for SwipeMessage Cell
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if listItems.isEmpty { // No items message
            let cell = tableView.dequeueReusableCellWithIdentifier("emptyListCell", forIndexPath: indexPath) as! EmptyListCell
            return cell
            
        } else if indexPath.row == listItems.count { // Swipe left message
            let cell = tableView.dequeueReusableCellWithIdentifier("swipeMessageCell", forIndexPath: indexPath) as! SwipeMessageCell
            return cell
            
        } else { // Item
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
            
            let item = listItems[indexPath.row]
            
            cell.titleLabel.text = item.title
            cell.isbnLabel.text = "isbn: \(item.isbn)"
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if listItems.isEmpty {
            return tableView.bounds.height - tableView.contentInset.top
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        println("cell.height: \(cell.bounds.height)")
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Actions
    
    @IBAction func userInfoPressed(sender: AnyObject) {
        performSegueWithIdentifier("showUserInfo", sender: sender)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToListViewController (sender: UIStoryboardSegue){
        let scannerVC = sender.sourceViewController as! ScannerVC
        
        if let sku = scannerVC.detectionString {
            println("sku: \(sku)")
            
//            let fetchRequest = NSFetchRequest(entityName: "Book")
//            
//            if let results = moc!.executeFetchRequest(fetchRequest, error: nil) as? [Book] {
//                self.scannedBooks.append(results.first!)
//            }
        }
        
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
