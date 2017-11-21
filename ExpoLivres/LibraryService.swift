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
        let url = URL(string: GlobalConstants.updateLibraryURL)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseServerData)
        task.resume()
    }
    
    class func parseServerData(_ data: Data?, response: URLResponse?, error: Error?) {
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
            
            context.performAndWait {
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
    
    class func parseJsonDictionaryFromData(_ data: Data) throws -> Dictionary<String, Any> {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonDictionary = json as? Dictionary<String, AnyObject> else { throw AppError.parsingJSONRootDictionary }
        
        return jsonDictionary
    }
    
    class func updateChecksumFromJsonDictionary(_ jsonDictionary: Dictionary<String, Any>) throws {
        guard let checksum = jsonDictionary["md5_checksum"] as? String else { throw AppError.parsingJSONMd5Checksum }
        persistenceService.checksum = checksum
    }

    class func parseBookDictionariesFromJsonDictionary(_ jsonDictionary: Dictionary<String, Any>) throws -> [Dictionary<String, String>] {
        guard let bookDictionaries = jsonDictionary["books"] as? [Dictionary<String, String>] else { throw AppError.parsingJSONBooks }
        return bookDictionaries
    }
}
