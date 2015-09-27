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
    
    var context: NSManagedObjectContext?
    var completionInvoked = false
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        context = setUpInMemoryManagedObjectContext()
        completionInvoked = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        context = nil
        
        super.tearDown()
    }
    
    func testParseServerDataExitsWithError() {
        let error = NSError(domain: "Test", code: 0, userInfo: nil)
        let data = NSData()
        
        LibraryService.parseServerData(data, response: nil, error: error)
        
        XCTAssertFalse(completionInvoked)
    }
}
