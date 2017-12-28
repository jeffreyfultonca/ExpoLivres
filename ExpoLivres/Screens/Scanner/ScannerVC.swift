import UIKit
import AVFoundation
import JFCToolKit

// MARK: - ScannerViewControllerDelegate

protocol ScannerViewControllerDelegate: class {
    func scannerViewController(
        _ scannerViewController: ScannerViewController,
        didScanSku sku: String
    )
}

// MARK: - ScannerViewData

struct ScannerViewData {
    let cancelButtonTitle: String
}

// MARK: - ScannerViewController

class ScannerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Stored Properties
    
    weak var delegate: ScannerViewControllerDelegate?
    
    private let session: AVCaptureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.previewLayer.frame = self.view.bounds
            self.previewLayer.connection?.videoOrientation = .currentDeviceOrientation
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - Setup
    
    private func setupCaptureSession() {
        // For the sake of discussion this is the camera
        guard let device = AVCaptureDevice.default(for: .video) else {
            // TODO: Handle.
            print("Unable to access default AVCaptureDevice for .video")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
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
    
    // MARK: - Update
    
    func update(with viewData: ScannerViewData) {
        self.loadViewIfNeeded()
        
        self.cancelButton.setTitle(viewData.cancelButtonTitle, for: UIControlState())
    }
    
    // MARK: - Actions
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - LoadableFromStoryboard

extension ScannerViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "Scanner" }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
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
        guard let metadata = metadataObjects.first(where: { barCodeTypes.contains($0.type) }) else { return }
        guard let sku = (metadata as? AVMetadataMachineReadableCodeObject)?.stringValue else { return }
        
        // Load
        let beepURL = Bundle.main.url(forResource: "beep", withExtension: "wav")!
        var beepSound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(beepURL as CFURL, &beepSound)
        
        // Play
        AudioServicesPlaySystemSound( SystemSoundID(kSystemSoundID_Vibrate) )
        AudioServicesPlaySystemSound(beepSound)
        
        self.session.stopRunning()
        
        self.delegate?.scannerViewController(self, didScanSku: sku)
    }
}
