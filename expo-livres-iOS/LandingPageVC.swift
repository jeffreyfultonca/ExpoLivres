//
//  LandingPageVC.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

class LandingPageVC: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var frenchButton: LandingPageGradientButton!
    @IBOutlet weak var englishButton: LandingPageGradientButton!
    
    override func viewDidDisappear(animated: Bool) {
        backgroundImageView.image = nil
        logoImageView.image = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        backgroundImageView.image = UIImage(named: "LandingPageBackground")
        logoImageView.image = UIImage(named: "Logo")
    }
    
    deinit {
        println("LandingPageVC.deinit")
    }
    
    @IBAction func enterApplicationPressed(sender: AnyObject?) {
        performSegueWithIdentifier("enterApplication", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let senderButton = sender as? LandingPageGradientButton {
            
            if senderButton == frenchButton {
                println("Set language to french")
            } else {
                println("Set language to english")
            }
        }
        
    }
}

