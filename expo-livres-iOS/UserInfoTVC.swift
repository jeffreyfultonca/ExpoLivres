//
//  UserInfoTVC.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

class UserInfo {
    
    class var isValid: Bool {
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let
            organization = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Organization),
            name = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Name),
            email = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Email)
        {
            return organization.isNotEmpty && name.isNotEmpty && email.isNotEmpty && email.isEmail
            
        } else {
            return false
        }
    }
    
    class var isNotValid: Bool {
        return !self.isValid
    }
}

class UserInfoTVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var poTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateUIForLanguage",
            name: GlobalConstants.Notification.LanguageChanged,
            object: nil
        )
        
        let font = UIFont.systemFontOfSize(17)
        languageSegmentedControl.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.allZeros)

        organizationTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Organization)
        poTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.PO)
        nameTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Name)
        emailTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Email)
        
        okButton.enabled = userEnteredValidInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        let currentLanguageIndex = LanguageService.currentLanguage.rawValue
        languageSegmentedControl.selectedSegmentIndex = currentLanguageIndex
        println("Selected Index: \(languageSegmentedControl.selectedSegmentIndex)")
    }
    
    deinit {
        println("UserInfo.deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func updateUIForLanguage() {
        self.navigationItem.title = LanguageService.userInfoTitle
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TextEntryCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    // MARK: - Action
    
    @IBAction func okPressed(sender: AnyObject) {
        self.tableView.endEditing(false)
        self.saveUserInfo()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func languageSegmentControlValueChanged(sender: AnyObject) {
        tableView.endEditing(false)
        LanguageService.currentLanguage = (languageSegmentedControl.selectedSegmentIndex == 0) ? .French : .English
    }
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        okButton.enabled = userEnteredValidInfo()
    }
    
    // MARK: - Custom Delegate
    
    func textEntryCellDidChangeText(text: String, forIndexPath indexPath: NSIndexPath) {
        println("TextEntryCellDidChangeText: \(text) for indexPath: \(indexPath)")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
        case self.organizationTextField:
            self.poTextField.becomeFirstResponder()
            
        case self.poTextField:
            self.nameTextField.becomeFirstResponder()
            
        case self.nameTextField:
            self.emailTextField.becomeFirstResponder()
            
        case emailTextField:
            self.organizationTextField.becomeFirstResponder()
            
        default:
            break
        }
        
        return true
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
