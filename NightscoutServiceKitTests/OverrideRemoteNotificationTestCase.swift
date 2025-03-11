//
//  OverrideRemoteNotificationTestCase.swift
//  NightscoutUploadKitTests
//
//  Created by Bill Gestrich on 2/25/23.
//  Copyright © 2023 Pete Schwamb. All rights reserved.
//

import XCTest
@testable import NightscoutServiceKit

final class OverrideRemoteNotificationTestCase: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testParseOverrideNotification_ValidPayload_Succeeds() throws {
        
        //Arrange
        let expectedRemoteAddress = "::ffff:11.2.44.155"
        let sentAtDateString = "2023-02-25T20:46:35.778Z"
        let expectedSentAtDate = dateFormatter().date(from: sentAtDateString)!
        let expirationDateString = "2023-02-25T20:51:35.778Z"
        let expectedExpirationDate = dateFormatter().date(from: expirationDateString)!
        let expectedName = "Exercise"
        let expectedDurationInMinutes = 15.1
        let expectedUpdateAutoBolusCarbsActive = true
        let expectedAutoBolusCarbsActive = false
        
        let notification: [String: Any] = [
            "remote-address": expectedRemoteAddress,
            "sent-at": sentAtDateString,
            "expiration": expirationDateString,
            "override-name": expectedName,
            "override-duration-minutes": expectedDurationInMinutes,
            "override-update-auto-bolus-carbs-active": expectedUpdateAutoBolusCarbsActive,
            "override-auto-bolus-carbs-active": expectedAutoBolusCarbsActive
        ]
        
        //Act
        let overrideNotification = try OverrideRemoteNotification(dictionary: notification)
        
        //Assert
        XCTAssertEqual(overrideNotification.remoteAddress, expectedRemoteAddress)
        XCTAssertEqual(overrideNotification.sentAt, expectedSentAtDate)
        XCTAssertEqual(overrideNotification.expiration, expectedExpirationDate)
        XCTAssertEqual(overrideNotification.name, expectedName)
        XCTAssertEqual(overrideNotification.durationInMinutes, expectedDurationInMinutes)
        XCTAssertEqual(overrideNotification.updateAutoBolusCarbsActive, expectedUpdateAutoBolusCarbsActive)
        XCTAssertEqual(overrideNotification.autoBolusCarbsActive, expectedAutoBolusCarbsActive)
    }
    
    
    //MARK: Utils
    
    func dateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
}
