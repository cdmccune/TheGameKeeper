//
//  DarkModeStyledUITextFieldTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 5/3/24.
//

import XCTest
@testable import Whats_The_Score

final class DarkModeStyledUITextFieldTests: XCTestCase {
    
    var textField: DarkModeStyledUITextField!
    
    override func setUp() {
        super.setUp()
        textField = DarkModeStyledUITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    override func tearDown() {
        textField = nil
        super.tearDown()
    }
    
    
    // Test the initial setup configurations of the text field
    func test_InitialSetup() {
        XCTAssertEqual(textField.borderStyle, .roundedRect, "Border style should be rounded rect")
        XCTAssertEqual(textField.layer.cornerRadius, 5, "Corner radius should be set to 5")
        XCTAssertEqual(textField.layer.borderWidth, 0.5, "Border width should be set to 0.5")
        XCTAssertEqual(textField.layer.borderColor, UIColor.lightGray.withAlphaComponent(0.5).cgColor, "Border color should be light gray with 50% opacity")
        XCTAssertEqual(textField.clipsToBounds, true, "ClipsToBounds should be true")
        XCTAssertEqual(textField.textColor, UIColor.textColor, "Text color should be set to textColor")
        XCTAssertEqual(textField.backgroundColor, .clear, "Background color should be clear")
    }
    
    // Test that placeholder text color is updated correctly
    func test_PlaceholderTextColor() {
        textField.placeholder = "Test Placeholder"
        let expectedColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        let placeholderColor = textField.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        XCTAssertEqual(placeholderColor, expectedColor, "Placeholder text color should be light gray with 50% opacity")
    }
    
    // Test the dynamic update of placeholder text color when placeholder text changes
    func test_DynamicPlaceholderTextUpdate() {
        textField.placeholder = "Initial Placeholder"
        textField.placeholder = "Updated Placeholder"
        
        let expectedColor = UIColor.lightGray.withAlphaComponent(0.5)
        let placeholderColor = textField.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        XCTAssertEqual(placeholderColor, expectedColor, "Placeholder text color should update dynamically when placeholder text is changed")
    }
    
}
