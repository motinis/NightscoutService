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
    public let giveRecommendedBolus: Bool?
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
        case giveRecommendedBolus = "bolus"
        case notes = "notes"
    }
    
    public func absorptionTime() -> TimeInterval? {
        guard let absorptionInHours = absorptionInHours else {
            return nil
        }
        return TimeInterval(hours: absorptionInHours)
    }
    
    func toRemoteAction() -> Action {
        var giveBolus = giveRecommendedBolus ?? false
        if giveRecommendedBolus == nil && notes != nil { // notes gives backwards compatability with NS
            giveBolus = notes!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "bolus"
        }
        
        let action = CarbAction(amountInGrams: amount, absorptionTime: absorptionTime(), foodType: foodType, startDate: startDate,
                                giveRecommendedBolus: giveBolus)
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
