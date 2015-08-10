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
    
    override func drawRect(rect: CGRect) {
        // Draw bottom border
        let context = UIGraphicsGetCurrentContext()
        
        // Line characteristics
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor )
        CGContextSetLineWidth(context, 1.0)
        
        // Left line
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        
        CGContextStrokePath(context)
    }
    
}
