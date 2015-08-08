//
//  LandingPageGradientButton.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

class LandingPageGradientButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 2.0
        self.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).CGColor
        self.layer.borderWidth = 1.0
        
        self.layer.masksToBounds = true
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        let color1 = UIColor(white: 1.0, alpha: 1.0).CGColor
        let color2 = UIColor(red: 90.6, green: 89.4, blue: 93.3, alpha: 1.0).CGColor
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.frame = self.layer.bounds
        self.layer.addSublayer(gradientLayer)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
