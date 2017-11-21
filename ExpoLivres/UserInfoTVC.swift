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
    
    var persistenceService = PersistenceService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUIForLanguage()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUIForLanguage),
            name: NSNotification.Name(rawValue: GlobalConstants.Notification.LanguageChanged),
            object: nil
        )
        
        let font = UIFont.systemFont(ofSize: 17)
        languageSegmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
        
        languageSegmentedControl.selectedSegmentIndex = LanguageService.currentLanguage.rawValue

        organizationTextField.text = persistenceService.userOrganization
        poTextField.text = persistenceService.userPo
        nameTextField.text = persistenceService.userName
        emailTextField.text = persistenceService.userEmail
        
        okButton.isEnabled = userEnteredValidInfo()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        persistenceService.userOrganization = organizationTextField.text
        persistenceService.userPo = poTextField.text
        persistenceService.userName = nameTextField.text
        persistenceService.userEmail = emailTextField.text
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TextEntryCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Action
    
    @IBAction func okPressed(_ sender: AnyObject) {
        self.tableView.endEditing(false)
        self.saveUserInfo()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func languageSegmentControlValueChanged(_ sender: AnyObject) {
        tableView.endEditing(false)
        LanguageService.currentLanguage = (languageSegmentedControl.selectedSegmentIndex == 0) ? .french : .english
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        okButton.isEnabled = userEnteredValidInfo()
    }
    
    // MARK: - Custom Delegate
    
    func textEntryCellDidChangeText(_ text: String, forIndexPath indexPath: IndexPath) {
        print("TextEntryCellDidChangeText: \(text) for indexPath: \(indexPath)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
