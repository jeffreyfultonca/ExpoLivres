//
//  inputContainerView.swift
//  mySafetyApp
//
//  Created by Jeffrey Fulton on 2015-02-13.
//  Copyright (c) 2015 1 Life Workplace Safety and Health LTD. All rights reserved.
//

import UIKit

@IBDesignable class borderedView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
