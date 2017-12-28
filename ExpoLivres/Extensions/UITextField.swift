import UIKit

extension UITextField {
    var isNotEmpty: Bool {
        return self.text!.isNotEmpty
    }
    
    var isEmail: Bool {
        return self.text!.isEmail
    }
}
