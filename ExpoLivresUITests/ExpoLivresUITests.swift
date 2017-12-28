import XCTest

class ExpoLivresUITests: XCTestCase {
    
    // MARK: - Stored Properties
    
    private var app: XCUIApplication!
    
    // MARK: - Setup & Tear-down
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
      
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testCaptureLandingScreen() {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        attachment.name = "Landing Screen"
        add(attachment)
    }
    
    func testCaptureListScreen() {
        app.buttons["Get Started"].tap()
        
        let _ = app.tables/*@START_MENU_TOKEN@*/.staticTexts["No items in list"]/*[[".cells.staticTexts[\"No items in list\"]",".staticTexts[\"No items in list\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 3)
        
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        attachment.name = "Empty List"
        add(attachment)
    }
}
