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
                let context = PersistenceController.mainContext
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
                    
                    let localBooks = (try! context.executeFetchRequest(fetchRequest)) as! [Book]
                    
                    for localBook in localBooks {
                        context.deleteObject(localBook)
                    }
                    
                    print("Books.count: \(bookDictionaries.count)")
                    
                    // Insert all new books
                    for bookDictionary in bookDictionaries {
                        guard let title = bookDictionary["title"] else { throw Error.ParsingJSONAttribute(attribute: "title", forEntity: "Book") }
                        guard let sku = bookDictionary["sku"] else { throw Error.ParsingJSONAttribute(attribute: "sku", forEntity: "Book") }
                        Book.createWith(title: title, sku: sku, inContext: context)
                    }
                    
                    PersistenceController.saveContext(context)
                    
                } else {
                    print("Error could not parse JSON. Possibly because there are no books to update.")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
