//
//  Book.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import CoreData

class Book: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var sku: String
    
    static let entityName = "Book"
    
    class func createWith(title title: String, sku: String, inContext context: NSManagedObjectContext) -> Book {
        let newBook = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! Book
        
        newBook.title = title
        newBook.sku = sku
        
        return newBook
    }
    
    class func withSku(sku: String, inContext context: NSManagedObjectContext) -> Book? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "sku == %@", sku)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.executeFetchRequest(fetchRequest) as! [Book]
            return results.first
            
        } catch {
            print("Error fetching books: \(error)")
            return nil
        }
    }
}
