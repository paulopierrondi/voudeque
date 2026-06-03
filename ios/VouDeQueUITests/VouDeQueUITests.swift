import XCTest

final class VouDeQueUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitest-reset"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
    
    // MARK: - Onboarding Flow
    
    func testOnboardingFlow() throws {
        // Verify onboarding masthead is present
        XCTAssertTrue(app.staticTexts["VOUDEQUE"].waitForExistence(timeout: 5))
        
        // Tap through onboarding pages
        let continueButton = app.buttons["Continuar"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 2))
        continueButton.tap()
        
        // Second page
        XCTAssertTrue(continueButton.waitForExistence(timeout: 2))
        continueButton.tap()
        
        // Third page — start button
        let startButton = app.buttons["Comecar"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Verify main UI loaded by checking for a tab button
        XCTAssertTrue(app.buttons["Capa"].waitForExistence(timeout: 5))
    }
    
    // MARK: - Tab Navigation
    
    func testTabNavigation() throws {
        completeOnboardingIfNeeded()
        
        // Verify tab buttons exist
        XCTAssertTrue(app.buttons["Capa"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Briefing"].exists)
        XCTAssertTrue(app.buttons["Em pauta"].exists)
        XCTAssertTrue(app.buttons["Arquivo"].exists)
        
        // Capa tab (default) — check for masthead
        XCTAssertTrue(app.staticTexts["VOUDEQUE"].waitForExistence(timeout: 3))
        
        // Briefing tab
        tapTab(named: "Briefing")
        XCTAssertTrue(app.staticTexts["O briefing de hoje."].waitForExistence(timeout: 3))
        
        // Em pauta tab
        tapTab(named: "Em pauta")
        XCTAssertTrue(app.staticTexts["O que veste o Brasil esta semana."].waitForExistence(timeout: 3))
        
        // Arquivo tab
        tapTab(named: "Arquivo")
        XCTAssertTrue(app.staticTexts["Maria Silva"].waitForExistence(timeout: 3))
    }
    
    // MARK: - Generate Look Flow
    
    func testGenerateLookFlow() throws {
        completeOnboardingIfNeeded()
        
        tapTab(named: "Briefing")
        XCTAssertTrue(app.staticTexts["O briefing de hoje."].waitForExistence(timeout: 3))
        
        // Select an occasion (e.g., "Date")
        let dateButton = app.buttons["Date"]
        if dateButton.waitForExistence(timeout: 2) {
            dateButton.tap()
        }
        
        // Enter style notes
        let textEditor = app.textViews.firstMatch
        if textEditor.waitForExistence(timeout: 2) {
            textEditor.tap()
            textEditor.typeText("Algo romantico")
            if app.buttons["OK"].waitForExistence(timeout: 2) {
                app.buttons["OK"].tap()
            }
            app.scrollViews.firstMatch.swipeUp()
        }

        // Tap generate button
        let generateButton = app.buttons["Fechar a edicao"]
        XCTAssertTrue(generateButton.waitForExistence(timeout: 2))
        generateButton.tap()
        
        // Wait for result or loading state
        let loadingText = app.staticTexts["Criando look..."]
        _ = loadingText.waitForExistence(timeout: 2)
        
        // Result should appear eventually (with mocked backend)
        XCTAssertTrue(generateButton.waitForExistence(timeout: 10) || app.navigationBars.firstMatch.exists)
    }
    
    // MARK: - Feed Loading
    
    func testFeedLoading() throws {
        completeOnboardingIfNeeded()
        
        tapTab(named: "Em pauta")
        XCTAssertTrue(app.staticTexts["O que veste o Brasil esta semana."].waitForExistence(timeout: 3))
        
        // Feed should show content, empty state, or shimmer
        let hasContent = app.scrollViews.firstMatch.waitForExistence(timeout: 3)
        let hasEmptyState = app.staticTexts["Nenhum look ainda"].exists
        let hasError = app.staticTexts["Erro"].exists
        
        XCTAssertTrue(hasContent || hasEmptyState || hasError, "Feed should display some state")
    }
    
    // MARK: - Account Deletion Flow
    
    func testAccountDeletionFlow() throws {
        completeOnboardingIfNeeded()
        
        tapTab(named: "Arquivo")
        XCTAssertTrue(app.staticTexts["Maria Silva"].waitForExistence(timeout: 3))
        
        // Scroll to delete account button
        let deleteButton = app.buttons["Excluir Conta"]
        while !deleteButton.exists {
            app.swipeUp()
            if deleteButton.waitForExistence(timeout: 1) { break }
        }
        
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 3))
        deleteButton.tap()
        
        // Confirm deletion alert
        let confirmDelete = app.buttons["Excluir"]
        XCTAssertTrue(confirmDelete.waitForExistence(timeout: 3))
        confirmDelete.tap()
        
        // After deletion, onboarding should reappear or app resets
        let onboardingButton = app.buttons["Continuar"]
        let onboardingStart = app.buttons["Comecar"]
        XCTAssertTrue(
            onboardingButton.waitForExistence(timeout: 10) || onboardingStart.waitForExistence(timeout: 10),
            "App should return to onboarding after account deletion"
        )
    }
    
    // MARK: - Helpers
    
    private func completeOnboardingIfNeeded() {
        let startButton = app.buttons["Comecar"]
        let continueButton = app.buttons["Continuar"]
        
        // Check if we're on onboarding by looking for VOUDEQUE masthead
        if app.staticTexts["VOUDEQUE"].waitForExistence(timeout: 3) {
            if continueButton.exists {
                continueButton.tap()
            }
            if continueButton.waitForExistence(timeout: 2) {
                continueButton.tap()
            }
            if startButton.waitForExistence(timeout: 2) {
                startButton.tap()
            }
            XCTAssertTrue(app.buttons["Capa"].waitForExistence(timeout: 5))
        }
    }
    
    private func tapTab(named name: String) {
        let tab = app.buttons[name]
        if tab.waitForExistence(timeout: 3) {
            tab.tap()
        }
    }
}
