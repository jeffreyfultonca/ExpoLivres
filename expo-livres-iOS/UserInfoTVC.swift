//
//  UserInfoTVC.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

class UserInfoTVC: UITableViewController {

    @IBOutlet weak var okButton: UIBarButtonItem!
    
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var poTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = -1
     
        organizationTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Organization)
        poTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.PO)
        nameTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Name)
        emailTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Email)
        
        okButton.enabled = userEnteredValidInfo()
    }
    
    // MARK: - Helpers
    
    func userEnteredValidInfo() -> Bool {
        let organizationEntered = organizationTextField.isNotEmpty
        let nameEntered = nameTextField.isNotEmpty
        let emailEntered = emailTextField.isNotEmpty
        let emailValid = emailTextField.isEmail
        
        return organizationEntered && nameEntered && emailEntered && emailValid
    }
    
    func saveUserInfo() {
        defaults.setObject(organizationTextField.text, forKey: GlobalConstants.UserDefaultsKey.Organization)
        defaults.setObject(poTextField.text, forKey: GlobalConstants.UserDefaultsKey.PO)
        defaults.setObject(nameTextField.text, forKey: GlobalConstants.UserDefaultsKey.Name)
        defaults.setObject(emailTextField.text, forKey: GlobalConstants.UserDefaultsKey.Email)
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TextEntryCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    // MARK: - Action
    
    @IBAction func okPressed(sender: AnyObject) {
        self.tableView.endEditing(true)
        self.saveUserInfo()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        okButton.enabled = userEnteredValidInfo()
    }
    
    // MARK: - Custom Delegate
    
    func textEntryCellDidChangeText(text: String, forIndexPath indexPath: NSIndexPath) {
        println("TextEntryCellDidChangeText: \(text) for indexPath: \(indexPath)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
