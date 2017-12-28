import UIKit

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
