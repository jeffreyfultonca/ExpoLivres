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
        return appDelegate.managedObjectContext
    }()
    
    class func updateLibrary() {
        
        let url = NSURL(string: GlobalConstants.updateLibraryURL)!
        let request = NSURLRequest(URL: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, urlResponse, error  in
            
            // TODO: Refactor this for with Swift 2.0 error handling and unit test.
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                if let
                    jsonDictionary = json as? Dictionary<String, AnyObject>,
                    checksum = jsonDictionary["md5_checksum"] as? String,
                    bookDictionaries = jsonDictionary["books"] as? [Dictionary<String, String>]
                {
                    LocalStorageService.checksum = checksum
                    
                    // Clear database
                    let fetchRequest = NSFetchRequest(entityName: "Book")
                    fetchRequest.includesPropertyValues = false
                    
                    let localBooks = (try! self.moc.executeFetchRequest(fetchRequest)) as! [Book]
                    
                    for localBook in localBooks {
                        self.moc.deleteObject(localBook)
                    }
                    
                    print("Books.count: \(bookDictionaries.count)")
                    
                    // Insert all new books
                    for bookDictionary in bookDictionaries {
                        let localBook = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: self.moc) as! Book
                        localBook.title = bookDictionary["title"] as String!
                        localBook.sku = bookDictionary["sku"] as String!
                    }
                    
                    // Save
                    do {
                        try self.moc.save()
                    } catch {
                        print("Error saving: \(error)")
                    }
                } else {
                    print("Error could not parse JSON. Possibly because there are no books to update.")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    class func bookWithSku(sku: String) -> Book? {
        let fetchRequest = NSFetchRequest(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "sku == %@", sku)
        fetchRequest.fetchLimit = 1
        let results = (try! moc.executeFetchRequest(fetchRequest)) as! [Book]
        
        return results.first
    }
}
