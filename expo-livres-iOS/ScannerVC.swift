//
//  ScannerVC.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-09.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerVCDelegate: class {
    func scannerSuccessfullyScannedSku(sku: String)
}

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: ScannerVCDelegate?
    @IBOutlet weak var cancelButton: UIButton!
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
//    var highlightView   : UIView = UIView()
    
    var detectionString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.setTitle(LanguageService.cancel, forState: UIControlState.allZeros)
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var error : NSError? = nil
        
        
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        // If our input is not nil then add it to the session, otherwise we're kind of done!
        if input != nil {
            session.addInput(input)
        }
        else {
            // This is fine for a demo, do something real with this in your app. :)
            println(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.currentDeviceOrientation
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ context in
            self.previewLayer.frame = self.view.bounds
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.currentDeviceOrientation
            
        }, completion: nil)
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        let barCodeTypes = [
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeCode128Code
        ]
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)

                    // Load
                    let beepURL = NSBundle.mainBundle().URLForResource("beep", withExtension: "wav")
                    var beepSound: SystemSoundID = 0
                    AudioServicesCreateSystemSoundID(beepURL, &beepSound)
                    
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
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
