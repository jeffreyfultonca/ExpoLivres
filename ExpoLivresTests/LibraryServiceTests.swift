//
//  LibraryServiceTests.swift
//  ExpoLivres
//
//  Created by Jeffrey Fulton on 2015-09-26.
//  Copyright © 2015 Jeffrey Fulton. All rights reserved.
//

import XCTest
import CoreData
@testable import ExpoLivres

class LibraryServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        MockLibraryService.parseJSONDataInvoked = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseServerDataInvokesParseJSONDataWithDataAndNoError() {
        let data: NSData? = NSData()
        let error: NSError? = nil
        
        MockLibraryService.parseServerData(data, response: nil, error: error)
        
        XCTAssertTrue(MockLibraryService.parseJSONDataInvoked)
    }
    
    func testParseServerDataExitsWithDataAndError() {
        let data: NSData? = NSData()
        let error: NSError? = NSError(domain: "Test", code: 0, userInfo: nil)
        
        MockLibraryService.parseServerData(data, response: nil, error: error)
        
        XCTAssertFalse(MockLibraryService.parseJSONDataInvoked)
    }
    
    func testParseServerDataExitsWithNilData() {
        let data: NSData? = nil
        let error: NSError? = nil
        
        MockLibraryService.parseServerData(data, response: nil, error: error)
        
        XCTAssertFalse(MockLibraryService.parseJSONDataInvoked)
    }
    
    func testParseJsonDictionaryFromDataThrowsErrorForBadJSON() {
        let brokenJSONData = "{".dataUsingEncoding(NSUTF8StringEncoding)!
        do {
            try LibraryService.parseJsonDictionaryFromData(brokenJSONData)
            XCTFail("Previous call should have thrown error. This line in text should never execute.")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testParseJsonDictionaryFromDataThrowsErrorIfJsonNotCastableToDictionaryStringAnyObject() {
        let jsonData = "[1,2,3]".dataUsingEncoding(NSUTF8StringEncoding)!
        do {
            try LibraryService.parseJsonDictionaryFromData(jsonData)
            XCTFail("Previous call should have thrown error. This line in text should never execute.")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testUpdateChecksumFromJsonDictionaryThrowsErrorIfJsonMissingChecksum() {
        let jsonDictionary = ["missingChecksum": "some numbers"]
        do {
            try LibraryService.updateChecksumFromJsonDictionary(jsonDictionary)
            XCTFail("Previous call should have thrown error. This line in text should never execute.")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testUpdateChecksumFromJsonDictionaryThrowsErrorIfChecksumNotCastableToString() {
        let jsonDictionary = ["md5_checksum": 123]
        do {
            try LibraryService.updateChecksumFromJsonDictionary(jsonDictionary)
            XCTFail("Previous call should have thrown error. This line in text should never execute.")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testUpdateChecksumFromJsonDictionarySetsChecksumWhenJsonIsValid() {
        let mockPersistenceService = MockPersistenceService()
        mockPersistenceService.checksumWasSet = false
        LibraryService.persistenceService = mockPersistenceService
        
        let jsonDictionary = ["md5_checksum": "123"]
        do {
            try LibraryService.updateChecksumFromJsonDictionary(jsonDictionary)
            XCTAssertTrue(mockPersistenceService.checksumWasSet)
        } catch {
            XCTFail("Error should not have been thrown.")
        }
    }
    
    func testParseBookDictionariesFromJsonDictionarySuccessfullyReturnsWhenValidDictionaryProvided() {
        let validJsonDictionary = ["books": [["name": "Valid name"]]]
        do {
            try LibraryService.parseBookDictionariesFromJsonDictionary(validJsonDictionary)
            XCTAssertTrue(true)
        } catch {
            XCTFail("Previous call should have thrown error. This line in text should never execute.")
        }
    }

    
    func testParseBookDictionariesFromJsonDictionaryThrowsErrorIfJsonMissingBooksDictionaryStringString() {
        let jsonDictionary = ["books": [["name": 1]]]
        do {
            try LibraryService.parseBookDictionariesFromJsonDictionary(jsonDictionary)
            XCTFail("Previous call should have thrown error. This line in text should never execute.")
        } catch {
            XCTAssertTrue(true)
        }
    }
}

// MARK: - Mocks

class MockLibraryService: LibraryService {
    static var parseJSONDataInvoked = false
    
    override class func parseJsonDictionaryFromData(data: NSData) throws -> Dictionary<String, AnyObject> {
        parseJSONDataInvoked = true
        return Dictionary<String, AnyObject>()
    }
}
