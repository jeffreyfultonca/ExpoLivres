import Foundation

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var isEmail: Bool {
        let regex = try! NSRegularExpression(
            pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
            options: .caseInsensitive
        )
        
        return regex.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.count)) > 0
    }
}
