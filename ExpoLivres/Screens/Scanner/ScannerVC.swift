import UIKit
import AVFoundation

protocol ScannerVCDelegate: class {
    func scannerSuccessfullyScannedSku(_ sku: String)
}

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: ScannerVCDelegate?
    @IBOutlet weak var cancelButton: UIButton!
    
    let session: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var detectionString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.setTitle(LanguageService.cancel, for: UIControlState())
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            session.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: .main)
            session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = self.view.bounds
            previewLayer.connection?.videoOrientation = .currentDeviceOrientation
            previewLayer.videoGravity = .resizeAspectFill
            
            self.view.layer.insertSublayer(previewLayer, at: 0)
            
            // Start the scanner. You'll have to end it yourself later.
            session.startRunning()
            
        } catch {
            print("Error creating input device (camera): \(error)")
            // TODO: Display message to user maybe suggesting they authorize camera use in Settings app.
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.previewLayer.frame = self.view.bounds
            self.previewLayer.connection?.videoOrientation = .currentDeviceOrientation
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // This is called when we find a known barcode type with the camera.
    func metadataOutput(
        _ captureOutput: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection)
    {
        let barCodeTypes = [
            AVMetadataObject.ObjectType.ean13,
            AVMetadataObject.ObjectType.code128
        ]
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                if (metadata as AnyObject).type == barcodeType {
                    // Load
                    let beepURL = Bundle.main.url(forResource: "beep", withExtension: "wav")!
                    var beepSound: SystemSoundID = 0
                    AudioServicesCreateSystemSoundID(beepURL as CFURL, &beepSound)
                    
                    // Play
                    AudioServicesPlaySystemSound( SystemSoundID(kSystemSoundID_Vibrate) )
                    AudioServicesPlaySystemSound(beepSound)
                    
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    self.session.stopRunning()
                    
                    self.delegate?.scannerSuccessfullyScannedSku(detectionString)
                    
                    break
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
