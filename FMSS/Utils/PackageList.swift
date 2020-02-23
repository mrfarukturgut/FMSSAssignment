//
//  Codables.swift
//  FMSS
//
//  Created by Faruk Turgut on 22.02.2020.
//  Copyright © 2020 Faruk Turgut. All rights reserved.
//

import Foundation

struct PackageList: Codable {
    
    var packages: [Package]
    
    private enum CodingKeys: CodingKey {
        case packages
    }
    
    init(){
        self.packages = [Package]()
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.packages = try container.decode([Package].self, forKey: .packages)
        }catch let error {
            print(error.localizedDescription+" Initializing packages with an empty array.")
            self.packages = [Package]()
        }
    }
}

//Assuming that the didUseBefore is indicates whether the package is favorite or not
extension PackageList {
    struct Package: Codable, Identifiable {
        
        var id: UUID
        var name: String
        var desc: String
        var subscriptionType: SubscriptionType
        var didUseBefore: Bool
        var benefits: [String]
        var price: Float
        var tariff: Tariff
        var availableUntil: String
        var isFavorite: Bool
        
        private enum CodingKeys: CodingKey {
            case name, desc, subscriptionType, didUseBefore, benefits, price, tariff, availableUntil, isFavorite
        }

        //Assuming name, desc, subscriptionType, didUseBefore, Price, Tariff and avaliableUntil will never be empty.
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.desc = try container.decode(String.self, forKey: .desc)
            self.subscriptionType = try container.decode(SubscriptionType.self, forKey: .subscriptionType)
            self.didUseBefore = try container.decode(Bool.self, forKey: .didUseBefore)
            do {
                self.benefits = try container.decode([String].self, forKey: .benefits)
            }catch let error {
                print(error.localizedDescription+" Initializing benefits with an empty array.")
                self.benefits = [String]()
            }
            self.price = try container.decode(Float.self, forKey: .price)
            self.tariff = try container.decode(Tariff.self, forKey: .tariff)
            self.availableUntil = try container.decode(String.self, forKey: .availableUntil)
            self.id = UUID()
            do {
                self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
            }catch {
                self.isFavorite = self.didUseBefore
            }
        }
        
        mutating func changeFavoriteState() {
            self.isFavorite.toggle()
        }
    }

    struct Tariff: Codable {
        var data: String
        var talk: String
        var sms: String
    }
}

