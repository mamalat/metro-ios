//
//  MetroUITests.swift
//  MetroUITests
//
//  Created by Iaroslav Mamalat on 2019-06-23.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import XCTest
import Localize_Swift

var currentLanguage: (langCode: String, localeCode: String)? {
    let currentLocale = Locale(identifier: Locale.preferredLanguages.first!)
    guard let langCode = currentLocale.languageCode else {
        return nil
    }
    var localeCode = langCode
    if let scriptCode = currentLocale.scriptCode {
        localeCode = "\(langCode)-\(scriptCode)"
    } else if let regionCode = currentLocale.regionCode {
        localeCode = "\(langCode)-\(regionCode)"
    }
    return (langCode, localeCode)
}

func localizedString(_ key: String) -> String {
    let testBundle = Bundle(for: MetroUITests.self)
    if let currentLanguage = currentLanguage,
        let testBundlePath = testBundle.path(forResource: currentLanguage.localeCode, ofType: "lproj")
        ?? testBundle.path(forResource: currentLanguage.langCode, ofType: "lproj"),
        let localizedBundle = Bundle(path: testBundlePath) {

        return NSLocalizedString(key, bundle: localizedBundle, comment: "")
    }
    return "?"
}

class MetroUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        snapshot("0Launch")
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.textFields[localizedString("from")].tap()

        let fromTextField = app.textFields[localizedString("from")].firstMatch
        fromTextField.typeText(localizedString("pozniaky"))

        let cellsQuery = collectionViewsQuery.cells
        cellsQuery.otherElements.containing(.staticText, identifier: localizedString("pozniaky")).element.tap()
        collectionViewsQuery.textFields[localizedString("to")].tap()

        let toTextField = app.textFields[localizedString("to")].firstMatch
        toTextField.typeText(localizedString("olimpiiska"))
        cellsQuery.otherElements.containing(.staticText, identifier: localizedString("olimpiiska")).element.tap()
        snapshot("1Launch")
        collectionViewsQuery.buttons[localizedString("get-directions")].tap()
        snapshot("2Launch")
        let navigationBar = app.navigationBars[localizedString("directions")]
        navigationBar.buttons[localizedString("back")].tap()
        app.buttons[localizedString("language")].tap()
        snapshot("3Launch")
    }

}
