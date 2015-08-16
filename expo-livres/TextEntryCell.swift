//
//  TextEntryCell.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

protocol TextEntryCellDelegate: class {
    func textEntryCellDidChangeText(text: String, forIndexPath indexPath: NSIndexPath)
}

class TextEntryCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
}
