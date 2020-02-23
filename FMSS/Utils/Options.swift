//
//  Options.swift
//  FMSS
//
//  Created by Faruk Turgut on 22.02.2020.
//  Copyright © 2020 Faruk Turgut. All rights reserved.
//

import Foundation

enum Options {
    
    struct FilterOptions {
        var byPrice: Options.Filter
        var byKeyword: Options.Filter
        
        func getFilters() -> [Options.Filter] {
            var filters = [Options.Filter]()
            filters.append(self.byPrice)
            filters.append(self.byKeyword)
            return filters
        }
    }
    
    enum Sort {
        case data, talk, sms
        
        var turkish: String {
            switch self {
            case .data:
                return "Veri"
            case .sms:
                return "SMS"
            case .talk:
                return "Konuşma"
            }
        }
    }
    
    enum Filter {
        case byPrice(from: Float, to: Float)
        case byKeyword(keyword: String)
        case none
    }
}
