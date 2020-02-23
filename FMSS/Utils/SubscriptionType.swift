//
//  SubscriptionType.swift
//  FMSS
//
//  Created by Faruk Turgut on 22.02.2020.
//  Copyright © 2020 Faruk Turgut. All rights reserved.
//

import Foundation

//Assuming these are the only options for this key. If I had time to research, I would try find a way to add a unkown case that can hold the string value. However, it is tricky because of the getting that undecodable string value from JSONDecoder. I added the daily option.
enum SubscriptionType: String, Codable {
    case weekly, monthly, yearly, daily
}

extension SubscriptionType {
    var priority: Int {
        switch self {
        case .weekly:
            return 3
        case .monthly:
            return 2
        case .yearly:
            return 1
        default:
            return 4
        }
    }
    
    var value: String {
        switch self {
        case .weekly:
            return "Haftalık"
        case .monthly:
            return "Aylık"
        case .yearly:
            return "Yıllık"
        case .daily:
            return "Günlük"
        }
    }
}

extension SubscriptionType: Comparable {
    static func < (lhs: SubscriptionType, rhs: SubscriptionType) -> Bool {
        return lhs.priority < rhs.priority
    }
}
