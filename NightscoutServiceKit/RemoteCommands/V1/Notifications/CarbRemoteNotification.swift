//
//  CarbRemoteNotification.swift
//  NightscoutUploadKit
//
//  Created by Bill Gestrich on 2/25/23.
//  Copyright © 2023 Pete Schwamb. All rights reserved.
//

import Foundation
import LoopKit

public struct CarbRemoteNotification: RemoteNotification, Codable {
    
    public let amount: Double
    public let absorptionInHours: Double?
    public let foodType: String?
    public let startDate: Date?
    public let remoteAddress: String
    public let expiration: Date?
    public let sentAt: Date?
    public let otp: String?
    public let enteredBy: String?
    public let bolusType: BolusType?
    public let notes: String?

    enum CodingKeys: String, CodingKey {
        case remoteAddress = "remote-address"
        case amount = "carbs-entry"
        case absorptionInHours = "absorption-time"
        case foodType = "food-type"
        case startDate = "start-time"
        case expiration = "expiration"
        case sentAt = "sent-at"
        case otp = "otp"
        case enteredBy = "entered-by"
        case bolusType = "bolus-type"
        case notes = "notes"
    }
    
    public func absorptionTime() -> TimeInterval? {
        guard let absorptionInHours = absorptionInHours else {
            return nil
        }
        return TimeInterval(hours: absorptionInHours)
    }
    
    func toRemoteAction() -> Action {
        var bolusType = bolusType
        if bolusType == nil && notes != nil { // notes gives backwards compatability with NS
            let notes = notes!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if notes == "bolus recommended" {
                bolusType = .recommended
            } else if notes == "bolus-non-correcting" {
                bolusType = .nonCorrecting
            }
        }
        
        let action = CarbAction(amountInGrams: amount, absorptionTime: absorptionTime(), foodType: foodType, startDate: startDate, bolusType: bolusType)
        return .carbsEntry(action)
    }
    
    func validate(otpManager: OTPManager) throws {
        let expirationValidator = ExpirationValidator(expiration: expiration)
        let otpValidator = OTPValidator(sentAt: sentAt, otp: otp, otpManager: otpManager)
        try expirationValidator.validate()
        try otpValidator.validate()
    }
    
    public static func includedInNotification(_ notification: [String: Any]) -> Bool {
        return notification["carbs-entry"] != nil
    }
}
