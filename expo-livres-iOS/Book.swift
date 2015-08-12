//
//  Book.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import Foundation
import CoreData

@objc(Book)
class Book: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var sku: String
    
    class func createInMoc(moc: NSManagedObjectContext, title: String, sku: String) -> Book {
        let newBook = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: moc) as! Book
        
        newBook.title = title
        newBook.sku = sku
        
        return newBook
    }
}
