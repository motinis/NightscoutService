//
//  CarbAction.swift
//  LoopKit
//
//  Created by Bill Gestrich on 12/25/22.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import Foundation

public struct CarbAction: Codable{
    
    public let amountInGrams: Double
    public let absorptionTime: TimeInterval?
    public let foodType: String?
    public let startDate: Date?
    public let giveRecommendedBolus: Bool
    
    public init(amountInGrams: Double, absorptionTime: TimeInterval? = nil, foodType: String? = nil, startDate: Date? = nil,
                giveRecommendedBolus: Bool = false) {
        self.amountInGrams = amountInGrams
        self.absorptionTime = absorptionTime
        self.foodType = foodType
        self.startDate = startDate
        self.giveRecommendedBolus = giveRecommendedBolus
    }
}
