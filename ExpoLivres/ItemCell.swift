//
//  ItemCell.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-10.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Draw bottom border
        let context = UIGraphicsGetCurrentContext()
        
        // Line characteristics
        context?.setStrokeColor(UIColor.lightGray.cgColor )
        context?.setLineWidth(1.0)
        
        // Left line
        context?.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context?.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        context?.strokePath()
    }
    
}
