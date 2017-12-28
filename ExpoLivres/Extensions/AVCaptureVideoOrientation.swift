import UIKit
import AVFoundation

extension AVCaptureVideoOrientation {
    static var currentDeviceOrientation: AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .landscapeRight:
            return .landscapeLeft
        case .landscapeLeft:
            return .landscapeRight
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}
