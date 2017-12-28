import Foundation

public extension DispatchQueue {
    public func asyncAfter(seconds: Double, completion: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
}
