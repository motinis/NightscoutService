//
//  OverrideRemoteNotification.swift
//  NightscoutUploadKit
//
//  Created by Bill Gestrich on 2/25/23.
//  Copyright © 2023 Pete Schwamb. All rights reserved.
//

import Foundation
import LoopKit

public struct OverrideRemoteNotification: RemoteNotification, Codable {
    
    public let name: String
    public let durationInMinutes: Double?
    public let remoteAddress: String
    public let expiration: Date?
    public let sentAt: Date?
    public let enteredBy: String?
    public let otp: String?
    public let updateAutoBolusCarbsActive: Bool?
    public let autoBolusCarbsActive: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case name = "override-name"
        case remoteAddress = "remote-address"
        case durationInMinutes = "override-duration-minutes"
        case updateAutoBolusCarbsActive = "override-update-auto-bolus-carbs-active"
        case autoBolusCarbsActive = "override-auto-bolus-carbs-active"
        case expiration = "expiration"
        case sentAt = "sent-at"
        case enteredBy = "entered-by"
        case otp = "otp"
    }
    
    public func durationTime() -> TimeInterval? {
        guard let durationInMinutes = durationInMinutes else {
            return nil
        }
        return TimeInterval(minutes: durationInMinutes)
    }
    
    func toRemoteAction() -> Action {
        let action = OverrideAction(name: name, durationTime: durationTime(), updateAutoBolusCarbsActive: updateAutoBolusCarbsActive ?? false, autoBolusCarbsActive: autoBolusCarbsActive, remoteAddress: remoteAddress)
        return .temporaryScheduleOverride(action)
    }
    
    func otpValidationRequired() -> Bool {
        return false
    }
    
    public static func includedInNotification(_ notification: [String: Any]) -> Bool {
        return notification["override-name"] != nil
    }
}
