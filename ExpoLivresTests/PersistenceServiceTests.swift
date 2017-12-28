//
//  PersistenceServiceTests.swift
//  ExpoLivres
//
//  Created by Jeffrey Fulton on 2015-09-27.
//  Copyright © 2015 Jeffrey Fulton. All rights reserved.
//

//import XCTest
//@testable import ExpoLivres
//
//class PersistenceServiceTests: XCTestCase {
//    
//    let persistenceService = PersistenceService.sharedInstance
//    let defaults = UserDefaults.standard
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        clearNSUserDefaults()
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        clearNSUserDefaults()
//        super.tearDown()
//    }
//    
//    func clearNSUserDefaults() {
//        defaults.set(nil, forKey: PersistenceService.UserDefaultsKey.Checksum)
//        defaults.set(nil, forKey: PersistenceService.UserDefaultsKey.Language)
//        defaults.set(nil, forKey: PersistenceService.UserDefaultsKey.Organization)
//        defaults.set(nil, forKey: PersistenceService.UserDefaultsKey.PO)
//        defaults.set(nil, forKey: PersistenceService.UserDefaultsKey.Name)
//        defaults.set(nil, forKey: PersistenceService.UserDefaultsKey.Email)
//        defaults.set(nil, forKey: PersistenceService.UserDefaultsKey.StoredSkuList)
//    }
//    
//    /// Confirm our test setup is properly starting from nil.
//    func testChecksumShouldInitiallyBeNil() {
//        let checksum = defaults.object(forKey: PersistenceService.UserDefaultsKey.Checksum)
//        XCTAssertNil(checksum)
//    }
//    
//    // MARK: Language
//    
//    func testCurrentLanguageDefaultsToFrenchIfNotSet() {
//        let language = persistenceService.currentLanguage
//        XCTAssertEqual(language, Language.french)
//    }
//    
//    func testCurrentLanguageReturnsSameLanguageSet() {
//        persistenceService.currentLanguage = .english
//        XCTAssertEqual(persistenceService.currentLanguage, Language.english)
//        
//        persistenceService.currentLanguage = .french
//        XCTAssertEqual(persistenceService.currentLanguage, Language.french)
//    }
//    
//    // MARK: UserInfo
//    
//    func testUserOrganizationReturnsNilIfNotSet() {
//        XCTAssertNil(persistenceService.userOrganization)
//    }
//    
//    func testUserOrganizationReturnsSameValueSet() {
//        let organization = "Valid Organization"
//        persistenceService.userOrganization = organization
//        XCTAssertEqual(persistenceService.userOrganization, organization)
//    }
//    
//    func testUserPoReturnsNilIfNotSet() {
//        XCTAssertNil(persistenceService.userPo)
//    }
//    
//    func testUserPoReturnsSameValueSet() {
//        let po = "Valid Po"
//        persistenceService.userPo = po
//        XCTAssertEqual(persistenceService.userPo, po)
//    }
//    
//    func testUserNameReturnsNilIfNotSet() {
//        XCTAssertNil(persistenceService.userName)
//    }
//    
//    func testUserNameReturnsSameValueSet() {
//        let name = "Valid Name"
//        persistenceService.userName = name
//        XCTAssertEqual(persistenceService.userName, name)
//    }
//    
//    func testUserEmailReturnsNilIfNotSet() {
//        XCTAssertNil(persistenceService.userEmail)
//    }
//    
//    func testUserEmailReturnsSameValueSet() {
//        let email = "Valid Email"
//        persistenceService.userEmail = email
//        XCTAssertEqual(persistenceService.userEmail, email)
//    }
//    
//    // MARK: Checksum
//    
//    func testChecksumReturnsEmptyStringIfNotSet() {
//        let checksum = persistenceService.checksum
//        XCTAssertEqual(checksum, "")
//    }
//    
//    func testSettingChecksumToValidStringReturnsSameString() {
//        let checksum = "123"
//        persistenceService.checksum = checksum
//        XCTAssertEqual(persistenceService.checksum, checksum)
//    }
//    
//    // MARK: Book List
//    
//    func testStoredSkuListReturnsEmptyArrayStringIfNotSet() {
//        let storedSkuList = persistenceService.storedSkuList
//        XCTAssertEqual(storedSkuList, [])
//    }
//    
//    func testSettingSkuListToValidValueReturnsSameValue() {
//        let storedSkuList = ["123", "456", "789"]
//        persistenceService.storedSkuList = storedSkuList
//        XCTAssertEqual(persistenceService.storedSkuList, storedSkuList)
//    }
//    
//    func testAddSkuToListResultsInOneSkuInListWithSameValue() {
//        let skuToAdd = "123"
//        persistenceService.addToSkuList(skuToAdd)
//        let storedSkuList = persistenceService.storedSkuList
//        XCTAssertEqual(storedSkuList, [skuToAdd])
//    }
//    
//    func testAddSkuToListTwiceResultsInTwoSkusInListWithSameValues() {
//        let firstSkuToAdd = "123"
//        let secondSkuToAdd = "456"
//        
//        persistenceService.addToSkuList(firstSkuToAdd)
//        persistenceService.addToSkuList(secondSkuToAdd)
//        
//        let storedSkuList = persistenceService.storedSkuList
//        XCTAssertEqual(storedSkuList, [firstSkuToAdd, secondSkuToAdd])
//    }
//    
//    func testRemoveFromListAtIndex() {
//        persistenceService.storedSkuList = ["123", "456", "789"]
//        persistenceService.removeFromListAtIndex(1)
//        XCTAssertEqual(persistenceService.storedSkuList, ["123", "789"])
//    }
//    
//    func testClearList() {
//        persistenceService.storedSkuList = ["123", "456", "789"]
//        persistenceService.clearList()
//        XCTAssertEqual(persistenceService.storedSkuList, [])
//    }
//}

