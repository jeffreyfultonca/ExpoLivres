import UIKit
import JFCToolKit

// MARK: - ListViewControllerDelegate

protocol ListViewControllerDelegate: AnyObject {
    func didSelectUserInfo(listViewController: ListViewController)
    
    func listViewController(
        _ listViewController: ListViewController,
        didDeleteListItem listItem: ListItem
    )
    
    func didSelectSubmit(listViewController: ListViewController)
    func didSelectScan(listViewController: ListViewController)
}

// MARK: - ListViewData

struct ListViewData {
    let navigationItemTitle: String
    
    let submitLabelText: String
    let scanLabelText: String
    
    let isSubmitButtonEnabled: Bool
    let submitLabelAlpha: CGFloat
    
    let tableRows: [ListViewController.TableRow]
}

extension ListViewData {
    init(
        languageProvider: LanguageProvider,
        listProvider: ListProvider)
    {
        self.navigationItemTitle = languageProvider.listTitle
        self.submitLabelText = languageProvider.submit
        self.scanLabelText = languageProvider.scan
    
        let listItems = listProvider.items
        
        if listItems.isEmpty {
            self.isSubmitButtonEnabled = false
            self.submitLabelAlpha = 0.3
            
            self.tableRows = [
                .noItemsMessage(
                    heading: languageProvider.listEmptyHeading,
                    bodyScan: languageProvider.listBodyScan,
                    bodySubmit: languageProvider.listBodySubmit
                )
            ]
        } else {
            self.isSubmitButtonEnabled = true
            self.submitLabelAlpha = 1.0
            
            var tableRows = listItems.map { listItem in
                ListViewController.TableRow.item(
                    listItem: listItem,
                    deleteConfirmationTitle: languageProvider.remove
                )
            }
            tableRows.append(.swipeLeftMessage(swipeMessage: languageProvider.listSwipeMessage))
            self.tableRows = tableRows
        }
    }
}

// MARK: - ListViewController

class ListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitLabel: UILabel!
    
    @IBOutlet weak var scanLabel: UILabel!
    
    // MARK: - Stored Properties
    
    weak var delegate: ListViewControllerDelegate?
    
    enum TableRow {
        case noItemsMessage(heading: String, bodyScan: String, bodySubmit: String)
        case swipeLeftMessage(swipeMessage: String)
        case item(listItem: ListItem, deleteConfirmationTitle: String)
        
        var canBeEdited: Bool {
            switch self {
            case .noItemsMessage: return false
            case .swipeLeftMessage: return false
            case .item: return true
            }
        }
    }
    private var tableRows: [TableRow] = []
    
    enum TableUpdateOption {
        case noUpdate
        case reloadAllRows
        case appendItemRow
        case removeRow(listItem: ListItem)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 74.5
    }
    
    // MARK: - Update
    
    func update(with viewData: ListViewData, tableUpdateOption: TableUpdateOption) {
        self.loadViewIfNeeded()
        
        self.navigationItem.title = viewData.navigationItemTitle
        
        self.submitLabel.text = viewData.submitLabelText
        self.submitButton.isEnabled = viewData.isSubmitButtonEnabled
        self.submitLabel.alpha = viewData.submitLabelAlpha
        
        self.scanLabel.text = viewData.scanLabelText
        
        // Determine tableUpdateAction before updating tableRows because the previous values are used to determine indexPaths.
        let tableUpdateAction = self.tableUpdateAction(for: tableUpdateOption)
        self.tableRows = viewData.tableRows
        tableUpdateAction()
    }
    
    typealias TableUpdateAction = () -> Void
    
    private func tableUpdateAction(for updateOption: TableUpdateOption) -> TableUpdateAction {
        switch updateOption {
        case .noUpdate:
            return {}
            
        case .reloadAllRows:
            return { self.tableView.reloadSections([0], with: .fade) }
            
        case .appendItemRow:
            let lastItemIndexPath = IndexPath(row: tableRows.count - 1, section: 0)
            let swipeMessageIndexPath = IndexPath(row: tableRows.count, section: 0)
            
            return {
                self.tableView.insertRows(at: [lastItemIndexPath], with: .fade)
                self.tableView.scrollToRow(at: swipeMessageIndexPath, at: .bottom, animated: true)
            }
            
        case .removeRow(let listItem):
            guard let indexPath = self.indexPath(for: listItem) else {
                return { self.tableView.reloadData() }
            }
            
            return { self.tableView.deleteRows(at: [indexPath], with: .fade) }
        }
    }
    
    private func indexPath(for listItem: ListItem) -> IndexPath? {
        guard let rowIndex = tableRows.index(where: { tableRow in
            switch tableRow {
            case .item(let item, _): return item == listItem
            default: return false
            }
        }) else { return nil }
        
        return IndexPath(row: rowIndex, section: 0)
    }
    
    // MARK: - Actions
    
    @IBAction func userInfoPressed(_ sender: AnyObject) {
        delegate?.didSelectUserInfo(listViewController: self)
    }
    
    @IBAction func submitPressed(_ sender: AnyObject) {
        delegate?.didSelectSubmit(listViewController: self)
    }
    
    @IBAction func scanPressed(_ sender: AnyObject) {
        delegate?.didSelectScan(listViewController: self)
    }
}

// MARK: - LoadableFromStoryboard

extension ListViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "List" }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableRows[indexPath.row] {
        case .noItemsMessage(let heading, let bodyScan, let bodySubmit):
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyListCell", for: indexPath) as! EmptyListCell
            
            cell.headingLabel.text = heading
            cell.messageOneLabel.text = bodyScan
            cell.messageTwoLabel.text = bodySubmit
            
            return cell
        case .swipeLeftMessage(let swipeMessage):
            let cell = tableView.dequeueReusableCell(withIdentifier: "swipeMessageCell", for: indexPath) as! SwipeMessageCell
            
            cell.messageLabel.text = swipeMessage
            
            return cell
            
        case .item(let listItem, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
            
            cell.titleLabel.text = listItem.libraryItem.title
            cell.isbnLabel.text = "isbn: \(listItem.libraryItem.sku)"
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableRows[indexPath.row] {
        case .noItemsMessage:
            return tableView.bounds.height - tableView.contentInset.top
            
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableRows[indexPath.row].canBeEdited
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath)
    {
        switch editingStyle {
        case .delete:
            // Notify delegate of user action. Delegate responsible for updating datasource and instructing this view to perform appropriate animations via the update(:) api.
            switch tableRows[indexPath.row] {
            case .item(let listItem, _):
                delegate?.listViewController(self, didDeleteListItem: listItem)
                
            default:
                print("Error: User attempted to delete non-item tableRow at indexPath: ", indexPath)
            }
        case .insert, .none:
            break
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        switch tableRows[indexPath.row] {
        case .item(_, let deleteConfirmationTitle): return deleteConfirmationTitle
        default: return nil
        }
    }
}
