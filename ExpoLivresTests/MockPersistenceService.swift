//
//  MockPersistenceService.swift
//  ExpoLivres
//
//  Created by Jeffrey Fulton on 2015-09-27.
//  Copyright © 2015 Jeffrey Fulton. All rights reserved.
//

@testable import ExpoLivres

class MockPersistenceService: PersistenceService {
    var mockUserOrganization: String?
    var mockUserName: String?
    var mockUserEmail: String?
    var mockChecksum: String = ""
    
    var checksumWasSet = false
    
    override var userOrganization: String? {
        get { return self.mockUserOrganization }
        set { self.mockUserOrganization = newValue }
    }
    override var userName: String? {
        get { return self.mockUserName }
        set { self.mockUserName = newValue }
    }
    override var userEmail: String? {
        get { return self.mockUserEmail }
        set { self.mockUserEmail = newValue }
    }
    
    override var checksum: String {
        get { return self.mockChecksum }
        set {
            self.mockChecksum = newValue
            self.checksumWasSet = true
        }
    }
}