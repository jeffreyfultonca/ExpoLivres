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
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).CGColor
        self.layer.borderWidth = 1.0
        
        self.layer.masksToBounds = true
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        let color1 = UIColor(white: 1.0, alpha: 1.0).CGColor
        let color2 = UIColor(white: 0.9, alpha: 1.0).CGColor
        gradientLayer.colors = [color1, color2]
        
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.layer.bounds
    }
}
