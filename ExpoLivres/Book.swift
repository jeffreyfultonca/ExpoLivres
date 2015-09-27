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
    
    class func deleteAll(inContext context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        
        let books = try! context.executeFetchRequest(fetchRequest) as! [Book]
        
        for book in books {
            context.deleteObject(book)
        }

    }
    
    class func insertFromDictionaries(bookDictionaries: [Dictionary<String, String>],
        inContext context: NSManagedObjectContext) throws
    {
        for bookDictionary in bookDictionaries {
            guard let title = bookDictionary["title"] else { throw Error.ParsingJSONAttribute(attribute: "title", forEntity: "Book") }
            guard let sku = bookDictionary["sku"] else { throw Error.ParsingJSONAttribute(attribute: "sku", forEntity: "Book") }
            Book.createWith(title: title, sku: sku, inContext: context)
        }
    }
}
