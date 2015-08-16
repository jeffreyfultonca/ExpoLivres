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
        
        let url = NSURL(string: GlobalConstants.updateLibraryURL)!
        var request = NSMutableURLRequest(URL: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, urlResponse, error  in
            
            if let error = error {
                println("Error: \(error)")
                return
            }
            
            var jsonError: NSError?
            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &jsonError)
            
            if let error = jsonError {
                println("Error parsing JSON: \(error)")
                
            } else if let
                jsonDictionary = json as? Dictionary<String, AnyObject>,
                checksum = jsonDictionary["md5_checksum"] as? String,
                bookDictionaries = jsonDictionary["books"] as? [Dictionary<String, String>]
            {
                LocalStorageService.checksum = checksum
                
                // Clear database
                let fetchRequest = NSFetchRequest(entityName: "Book")
                fetchRequest.includesPropertyValues = false
                
                let localBooks = self.moc.executeFetchRequest(fetchRequest, error: nil) as! [Book]
                
                for localBook in localBooks {
                    self.moc.deleteObject(localBook)
                }
                
                println("Books.count: \(bookDictionaries.count)")
                
                // Insert all new books
                for bookDictionary in bookDictionaries {
                    let localBook = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: self.moc) as! Book
                    localBook.title = bookDictionary["title"] as String!
                    localBook.sku = bookDictionary["sku"] as String!
                }
                
                // Save
                var error: NSError?
                self.moc.save(&error)
                
                if let error = error {
                    println("Error saving: \(error)")
                }
                
            } else {
                println("Error could not parse JSON. Possibly because there are no books to update.")
            }
        }
        
        task.resume()
    }
    
    class func bookWithSku(sku: String) -> Book? {
        let fetchRequest = NSFetchRequest(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "sku == %@", sku)
        fetchRequest.fetchLimit = 1
        let results = moc.executeFetchRequest(fetchRequest, error: nil) as! [Book]
        
        return results.first
    }
}
