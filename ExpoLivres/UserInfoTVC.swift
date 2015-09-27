//
//  UserInfoTVC.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

class UserInfoTVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var poLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var poTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUIForLanguage()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateUIForLanguage",
            name: GlobalConstants.Notification.LanguageChanged,
            object: nil
        )
        
        let font = UIFont.systemFontOfSize(17)
        languageSegmentedControl.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState())
        
        languageSegmentedControl.selectedSegmentIndex = LanguageService.currentLanguage.rawValue

        organizationTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Organization)
        poTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.PO)
        nameTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Name)
        emailTextField.text = defaults.stringForKey(GlobalConstants.UserDefaultsKey.Email)
        
        okButton.enabled = userEnteredValidInfo()
    }
    
    deinit {
        print("UserInfo.deinit")
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
        
        self.organizationLabel.text = LanguageService.userInfoOrganization
        self.poLabel.text = LanguageService.userInfoPo
        self.nameLabel.text = LanguageService.userInfoName
        self.emailLabel.text = LanguageService.userInfoEmail
        
        self.organizationTextField.placeholder = LanguageService.required
        self.poTextField.placeholder = LanguageService.optional
        self.nameTextField.placeholder = LanguageService.required
        self.emailTextField.placeholder = LanguageService.required
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
        print("TextEntryCellDidChangeText: \(text) for indexPath: \(indexPath)")
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
}
