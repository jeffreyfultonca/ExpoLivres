//
//  LibraryService.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-11.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit
import CoreData

class LibraryService {
    
    static var moc: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
    }()
    
    class func updateLibrary() {
        // TODO: Move this to Service.
        let filePath = NSBundle.mainBundle().pathForResource("books", ofType: "json")!
        let data = NSData(contentsOfFile: filePath)!
        var jsonError: NSError?
        let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &jsonError)
        
        if let error = jsonError {
            println("Error parsing JSON: \(error)")
            
        } else if let
            jsonDictionary = json as? Dictionary<String, AnyObject>,
            bookDictionaries = jsonDictionary["books"] as? [Dictionary<String, String>]
        {
            // Clear database
            let fetchRequest = NSFetchRequest(entityName: "Book")
            fetchRequest.includesPropertyValues = false
            
            let localBooks = moc.executeFetchRequest(fetchRequest, error: nil) as! [Book]
            
            for localBook in localBooks {
                moc.deleteObject(localBook)
            }
            
            // Insert all new books
            for bookDictionary in bookDictionaries {
                let localBook = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: moc) as! Book
                localBook.title = bookDictionary["title"] as String!
                localBook.sku = bookDictionary["sku"] as String!
            }
            
            // Save
            var error: NSError?
            moc.save(&error)
            
            if let error = error {
                println("Error saving: \(error)")
            }
            
        } else {
            println("Error could not parse JSON.")
        }
    }
    
    class func bookWithSku(sku: String) -> Book? {
        let fetchRequest = NSFetchRequest(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "sku == %@", sku)
        fetchRequest.fetchLimit = 1
        let results = moc.executeFetchRequest(fetchRequest, error: nil) as! [Book]
        
        return results.first
    }
}
