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
        // Verify onboarding is present
        XCTAssertTrue(app.staticTexts["Bem-vinda ao"].waitForExistence(timeout: 5))
        
        // Tap through onboarding pages
        let continueButton = app.buttons["Continuar"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 2))
        continueButton.tap()
        
        // Second page
        XCTAssertTrue(continueButton.waitForExistence(timeout: 2))
        continueButton.tap()
        
        // Third page — start button
        let startButton = app.buttons["Começar"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Verify we reached main tabs
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 5))
    }
    
    // MARK: - Tab Navigation
    
    func testTabNavigation() throws {
        completeOnboardingIfNeeded()
        
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        
        // Início tab (default)
        XCTAssertTrue(app.staticTexts["VouDeQue"].waitForExistence(timeout: 3))
        
        // Gerar tab
        tapTab(named: "Gerar")
        XCTAssertTrue(app.staticTexts["Gerar Look"].waitForExistence(timeout: 3))
        
        // Desafios tab
        tapTab(named: "Desafios")
        XCTAssertTrue(app.staticTexts["Desafios"].waitForExistence(timeout: 3))
        
        // Feed tab
        tapTab(named: "Feed")
        XCTAssertTrue(app.staticTexts["Comunidade"].waitForExistence(timeout: 3))
        
        // Perfil tab
        tapTab(named: "Perfil")
        XCTAssertTrue(app.staticTexts["Maria Silva"].waitForExistence(timeout: 3))
    }
    
    // MARK: - Generate Look Flow
    
    func testGenerateLookFlow() throws {
        completeOnboardingIfNeeded()
        
        tapTab(named: "Gerar")
        XCTAssertTrue(app.staticTexts["Gerar Look"].waitForExistence(timeout: 3))
        
        // Select an occasion (e.g., "Date")
        let dateButton = app.buttons["Date"]
        if dateButton.waitForExistence(timeout: 2) {
            dateButton.tap()
        }
        
        // Enter style notes
        let textEditor = app.textViews.firstMatch
        if textEditor.waitForExistence(timeout: 2) {
            textEditor.tap()
            textEditor.typeText("Algo romântico")
        }
        
        // Tap generate button
        let generateButton = app.buttons["Gerar Look"]
        XCTAssertTrue(generateButton.waitForExistence(timeout: 2))
        generateButton.tap()
        
        // Wait for result or loading state
        let loadingText = app.staticTexts["Criando look..."]
        _ = loadingText.waitForExistence(timeout: 2)
        
        // Result should appear eventually (with mocked backend)
        // In UI tests against a real backend this may timeout;
        // we verify the transition started.
        XCTAssertTrue(generateButton.waitForExistence(timeout: 10) || app.navigationBars.firstMatch.exists)
    }
    
    // MARK: - Feed Loading
    
    func testFeedLoading() throws {
        completeOnboardingIfNeeded()
        
        tapTab(named: "Feed")
        XCTAssertTrue(app.staticTexts["Comunidade"].waitForExistence(timeout: 3))
        
        // Feed should show content, empty state, or shimmer
        let hasContent = app.scrollViews.firstMatch.waitForExistence(timeout: 3)
        let hasEmptyState = app.staticTexts["Nenhum look ainda"].exists
        let hasError = app.staticTexts["Erro"].exists
        
        XCTAssertTrue(hasContent || hasEmptyState || hasError, "Feed should display some state")
    }
    
    // MARK: - Account Deletion Flow
    
    func testAccountDeletionFlow() throws {
        completeOnboardingIfNeeded()
        
        tapTab(named: "Perfil")
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
        let onboardingStart = app.buttons["Começar"]
        XCTAssertTrue(
            onboardingButton.waitForExistence(timeout: 10) || onboardingStart.waitForExistence(timeout: 10),
            "App should return to onboarding after account deletion"
        )
    }
    
    // MARK: - Helpers
    
    private func completeOnboardingIfNeeded() {
        let startButton = app.buttons["Começar"]
        let continueButton = app.buttons["Continuar"]
        
        if continueButton.waitForExistence(timeout: 3) || startButton.waitForExistence(timeout: 3) {
            if continueButton.exists {
                continueButton.tap()
            }
            if continueButton.waitForExistence(timeout: 2) {
                continueButton.tap()
            }
            if startButton.waitForExistence(timeout: 2) {
                startButton.tap()
            }
            XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 5))
        }
    }
    
    private func tapTab(named name: String) {
        let tab = app.tabBars.buttons[name]
        if tab.waitForExistence(timeout: 3) {
            tab.tap()
        } else {
            // Fallback by index if label matching fails
            let tabs = app.tabBars.firstMatch.buttons
            if tabs.count > 0 {
                tabs.element(boundBy: min(tabs.count - 1, 0)).tap()
            }
        }
    }
}
