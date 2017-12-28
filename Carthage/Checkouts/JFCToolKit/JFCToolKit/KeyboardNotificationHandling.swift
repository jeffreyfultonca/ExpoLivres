import UIKit

/**
 Provides register/deregister functions for keyboard show/hide notifications.
 
**Usage Requirements**
 
 - Implementation of both `keyboardWillShow(_:)` and `keyboardWillHide(_:)` functions.
 - Must call `registerForKeyboardNotifications()` and `deregisterForKeyboardNotifications()` at some point in lifecycle. i.e. `viewDidLoad()` and `deinit`
 
 **Note**
 
 Includes convenience functions for full screen scrollViews which adjusts bottom contentInset/scrollIndicatorInsets to size of keyboard:
 - `adjustInsets(ofFullScreenScrollView: forKeyboardWillShowNotification:)`
 - `adjustInsets(ofFullScreenScrollView: forKeyboardWillHideNotification:)`
 
 To use call from within above required functions.
 
 */
public protocol KeyboardNotificationHandling: class {
    func keyboardWillShow(_ sender: Notification)
    func keyboardWillHide(_ sender: Notification)
}

public extension KeyboardNotificationHandling {
    public func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            forName: .UIKeyboardWillShow,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                self?.keyboardWillShow(notification)
            }
        )
        
        NotificationCenter.default.addObserver(
            forName: .UIKeyboardWillHide,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                self?.keyboardWillHide(notification)
            }
        )
    }
    
    public func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: .UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    
    /// Convenience implementation for full screen scrollView.
    public func adjustInsets(
        ofFullScreenScrollView scrollView: UIScrollView,
        forKeyboardWillShowNotification notification: Notification)
    {
        guard let info = notification.userInfo as? [String: NSValue] else { return }
        guard let value = info[UIKeyboardFrameEndUserInfoKey] else { return }
        
        let keyboardSize = value.cgRectValue.size
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    /// Convenience implementation for full screen scrollView.
    public func adjustInsets(
        ofFullScreenScrollView scrollView: UIScrollView,
        forKeyboardWillHideNotification notification: Notification)
    {
        let contentInsetBottom: CGFloat = 0
        scrollView.contentInset.bottom = contentInsetBottom
        scrollView.scrollIndicatorInsets.bottom = contentInsetBottom
    }
}
