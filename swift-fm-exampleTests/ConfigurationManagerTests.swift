//
//  ConfigurationManagerTests.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 30/09/24.
//


import XCTest
import Combine
import ROX
import ROXCore

@testable import swift_fm_example // Replace with your actual module name

class ConfigurationManagerTests: XCTestCase {
    var configurationManager: ConfigurationManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        configurationManager = ConfigurationManager.shared
        cancellables = []
    }

    override func tearDown() {
        configurationManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialValues() {
        // Test initial values
        XCTAssertFalse(configurationManager.enableTutorial)
        XCTAssertEqual(configurationManager.titleColor, Flags.INSTANCE.titleColors.value())
        XCTAssertEqual(configurationManager.titleSize, Flags.INSTANCE.titleSize.value())
        XCTAssertEqual(configurationManager.specialNumber, Flags.INSTANCE.specialNumber.value())
    }

    func testEnableTutorialFlag() {
        let expectation = XCTestExpectation(description: "enableTutorial updated")

        configurationManager.$enableTutorial
            .dropFirst() // Ignore the initial value
            .sink { newValue in
                XCTAssertFalse(newValue) // Expect it to be true
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Simulate fetching configuration
        let mockResult = RoxFetcherResult(fetcherStatus: .appliedFromNetwork,creationDate: Date(), errorDetails: nil, hasChanges: true)! // Adjust as necessary
        configurationManager.fetchConfiguration(for: mockResult)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testTitleColorUpdate() {
        let expectation = XCTestExpectation(description: "titleColor updated")

        configurationManager.$titleColor
            .dropFirst() // Ignore the initial value
            .sink { newValue in
                print("color == \(newValue)")
                XCTAssertEqual(newValue, "Blue") // Replace with expected value
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Simulate fetching configuration
        let mockResult = RoxFetcherResult(fetcherStatus: .appliedFromNetwork,creationDate: Date(), errorDetails: nil, hasChanges: true)! // Adjust as necessary
        configurationManager.fetchConfiguration(for: mockResult)

        wait(for: [expectation], timeout: 1.0)
    }
}
