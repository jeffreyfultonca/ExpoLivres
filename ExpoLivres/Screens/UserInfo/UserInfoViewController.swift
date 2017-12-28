import UIKit
import JFCToolKit

// MARK: - UserInfoViewControllerDelegate

protocol UserInfoViewControllerDelegate: AnyObject {
    func userInfoViewController(
        _ userInfoViewController: UserInfoViewController,
        didSelectLanguage language: Language
    )
    
    func didUpdateUserInfo(userInfoViewController: UserInfoViewController)
    func didSelectOK(userInfoViewController: UserInfoViewController)
}

// MARK: - UserInfoViewData

struct UserInfoViewData {
    let navigationItemTitle: String
    let languageSegmentedControlSelectedIndex: Int
    let isOkButtonEnabled: Bool
    
    let organizationDescriptionText: String
    let purchaseOrderDescriptionText: String
    let nameDescriptionText: String
    let emailDescriptionText: String
    
    let organizationPlaceholder: String
    let purchaseOrderPlaceholder: String
    let namePlaceholder: String
    let emailPlaceholder: String
    
    let organizationValueText: String?
    let purchaseOrderValueText: String?
    let nameValueText: String?
    let emailValueText: String?
}

extension UserInfoViewData {
    init(
        languageProvider: LanguageProvider,
        userProvider: UserProvider)
    {
        self.navigationItemTitle = languageProvider.userInfoTitle
        self.languageSegmentedControlSelectedIndex = UserInfoViewData.languageControlIndex(
            for: languageProvider.selectedLanguage
        )
        self.isOkButtonEnabled = userProvider.user.isValid
        
        self.organizationDescriptionText = languageProvider.userInfoOrganization
        self.purchaseOrderDescriptionText = languageProvider.userInfoPo
        self.nameDescriptionText = languageProvider.userInfoName
        self.emailDescriptionText = languageProvider.userInfoEmail
        
        self.organizationPlaceholder = languageProvider.required
        self.purchaseOrderPlaceholder = languageProvider.optional
        self.namePlaceholder = languageProvider.required
        self.emailPlaceholder = languageProvider.required
        
        self.organizationValueText = userProvider.user.organization
        self.purchaseOrderValueText = userProvider.user.purchaseOrder
        self.nameValueText = userProvider.user.name
        self.emailValueText = userProvider.user.email
    }
    
    private static func languageControlIndex(for selectedLanguage: Language) -> Int {
        switch selectedLanguage {
        case .french: return 0
        case .english: return 1
        }
    }
}

// MARK: - UserInfoViewController

class UserInfoViewController: UITableViewController {
    
    // MARK: - Outlets

    @IBOutlet private var languageSegmentedControl: UISegmentedControl!
    @IBOutlet private var okButton: UIBarButtonItem!
    
    @IBOutlet private var organizationDescriptionLabel: UILabel!
    @IBOutlet private var purchaseOrderDescriptionLabel: UILabel!
    @IBOutlet private var nameDescriptionLabel: UILabel!
    @IBOutlet private var emailDescriptionLabel: UILabel!
    
    @IBOutlet private var organizationTextField: UITextField!
    @IBOutlet private var purchaseOrderTextField: UITextField!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    
    // MARK: - Stored Properties
    
    weak var delegate: UserInfoViewControllerDelegate?
    
    // MARK: - Computed Properties
    
    var organization: String { return organizationTextField.text ?? "" }
    var purchaseOrder: String { return purchaseOrderTextField.text ?? "" }
    var name: String { return nameTextField.text ?? "" }
    var email: String { return emailTextField.text ?? "" }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLanguageSegmentedControl()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupLanguageSegmentedControl() {
        let font = UIFont.systemFont(ofSize: 17)
        languageSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: UIControlState())
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Update
    
    func update(with viewData: UserInfoViewData) {
        self.loadViewIfNeeded()
        
        self.navigationItem.title = viewData.navigationItemTitle
        
        if languageSegmentedControl.selectedSegmentIndex != viewData.languageSegmentedControlSelectedIndex {
            languageSegmentedControl.selectedSegmentIndex = viewData.languageSegmentedControlSelectedIndex
        }
        
        okButton.isEnabled = viewData.isOkButtonEnabled
        
        organizationDescriptionLabel.text = viewData.organizationDescriptionText
        purchaseOrderDescriptionLabel.text = viewData.purchaseOrderDescriptionText
        nameDescriptionLabel.text = viewData.nameDescriptionText
        emailDescriptionLabel.text = viewData.emailDescriptionText
        
        organizationTextField.placeholder = viewData.organizationPlaceholder
        purchaseOrderTextField.placeholder = viewData.purchaseOrderPlaceholder
        nameTextField.placeholder = viewData.namePlaceholder
        emailTextField.placeholder = viewData.emailPlaceholder
        
        if organizationTextField.text != viewData.organizationValueText {
            organizationTextField.text = viewData.organizationValueText
        }
        if purchaseOrderTextField.text != viewData.purchaseOrderValueText {
            purchaseOrderTextField.text = viewData.purchaseOrderValueText
        }
        if nameTextField.text != viewData.nameValueText {
            nameTextField.text = viewData.nameValueText
        }
        if emailTextField.text != viewData.emailValueText {
            emailTextField.text = viewData.emailValueText
        }
    }
    
    // MARK: - Action
    
    @IBAction func languageSegmentControlValueChanged(_ sender: AnyObject) {
        let selectedLanguage: Language
        
        switch languageSegmentedControl.selectedSegmentIndex {
        case 0: selectedLanguage = .french
        default: selectedLanguage = .english
        }
        
        delegate?.userInfoViewController(self, didSelectLanguage: selectedLanguage)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.didUpdateUserInfo(userInfoViewController: self)
    }
    
    @IBAction func okPressed(_ sender: AnyObject) {
        tableView.endEditing(true)
        delegate?.didSelectOK(userInfoViewController: self)
    }
}

// MARK: - LoadableFromStoryboard

extension UserInfoViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "UserInfo" }
}

// MARK: - UITableViewDelegate

extension UserInfoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TextEntryCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        return UITableViewAutomaticDimension
    }
}

// MARK: - UITextFieldDelegate

extension UserInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.organizationTextField:
            self.purchaseOrderTextField.becomeFirstResponder()
            
        case self.purchaseOrderTextField:
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
