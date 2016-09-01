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
    static var persistenceService = PersistenceService.sharedInstance
    
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
            let jsonDictionary = try parseJsonDictionaryFromData(data)
            try updateChecksumFromJsonDictionary(jsonDictionary)
            let bookDictionaries = try parseBookDictionariesFromJsonDictionary(jsonDictionary)
            
            let context = PersistenceService.sharedInstance.backgroundContext
            
            context.performBlockAndWait {
                Book.deleteAll(inContext: context)
                do { try Book.insertFromDictionaries(bookDictionaries, inContext: context) }
                catch { print("Error inserting bookDictionaries: \(error)") }
                
                PersistenceService.sharedInstance.saveContext(context)
                context.reset()
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
    class func parseJsonDictionaryFromData(data: NSData) throws -> Dictionary<String, AnyObject> {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        guard let jsonDictionary = json as? Dictionary<String, AnyObject> else { throw Error.ParsingJSONRootDictionary }
        
        return jsonDictionary
    }
    
    class func updateChecksumFromJsonDictionary(jsonDictionary: Dictionary<String, AnyObject>) throws {
        guard let checksum = jsonDictionary["md5_checksum"] as? String else { throw Error.ParsingJSONMd5Checksum }
        persistenceService.checksum = checksum
    }

    class func parseBookDictionariesFromJsonDictionary(jsonDictionary: Dictionary<String, AnyObject>) throws -> [Dictionary<String, String>] {
        guard let bookDictionaries = jsonDictionary["books"] as? [Dictionary<String, String>] else { throw Error.ParsingJSONBooks }
        return bookDictionaries
    }
}