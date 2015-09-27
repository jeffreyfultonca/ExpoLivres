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
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: parseServerData)
        task.resume()
    }
    
    class func parseServerData(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let data = data else {
            print("Failed to download data from server.")
            return
        }
        
        do {
            let json = try parseJSONData(data, options: [])
            
            guard let jsonDictionary = json as? Dictionary<String, AnyObject> else { throw Error.ParsingJSONRootDictionary }
            guard let checksum = jsonDictionary["md5_checksum"] as? String else { throw Error.ParsingJSONMd5Checksum }
            guard let bookDictionaries = jsonDictionary["books"] as? [Dictionary<String, String>] else { throw Error.ParsingJSONBooks }
            
            LocalStorageService.checksum = checksum
            
            let context = PersistenceController.mainContext
            
            LibraryService.deleteAllBooks(context)
            try LibraryService.insertBooks(bookDictionaries, inContext: context)
            
            PersistenceController.saveContext(context)
            context.reset()
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
    class func parseJSONData(data: NSData, options: NSJSONReadingOptions) throws -> AnyObject {
        return try NSJSONSerialization.JSONObjectWithData(data, options: options)
    }
    
    class func deleteAllBooks(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "Book")
        fetchRequest.includesPropertyValues = false
        
        let localBooks = try! context.executeFetchRequest(fetchRequest) as! [Book]
        
        for localBook in localBooks {
            context.deleteObject(localBook)
        }
    }
    
    class func insertBooks(dictionaries: [Dictionary<String, String>], inContext context: NSManagedObjectContext) throws {
        for bookDictionary in dictionaries {
            guard let title = bookDictionary["title"] else { throw Error.ParsingJSONAttribute(attribute: "title", forEntity: "Book") }
            guard let sku = bookDictionary["sku"] else { throw Error.ParsingJSONAttribute(attribute: "sku", forEntity: "Book") }
            Book.createWith(title: title, sku: sku, inContext: context)
        }
    }
}
