//
//  JSONController.swift
//  FMSS
//
//  Created by Faruk Turgut on 19.02.2020.
//  Copyright © 2020 Faruk Turgut. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PackagesViewModel: ObservableObject {
    
    @Published var filteredPackages: [PackageList.Package] = [PackageList.Package]()
    
    @Published var currentSortOption: Options.Sort = .data {
        didSet{
            self.sort()
        }
    }
    
    @Published var currentFilterOptions: Options.FilterOptions = Options.FilterOptions(byPrice: .none, byKeyword: .none) {
        didSet{
            self.filter()
        }
    }
    
    @Published var searchKeyword: String = String() {
        didSet{
            if self.searchKeyword.count > 0 {
                self.currentFilterOptions.byKeyword = .byKeyword(keyword: self.searchKeyword)
            }else{
                self.currentFilterOptions.byKeyword = .none
            }
        }
    }
    
    private var allPackages: [PackageList.Package] = [PackageList.Package]() {
        didSet {
            self.filteredPackages = self.allPackages
        }
    }
    
    private let defaults: UserDefaults = UserDefaults.standard
    private let encoder: JSONEncoder = JSONEncoder()
    private let decoder: JSONDecoder = JSONDecoder()
    
    init(){
        do {
            print("trying to read")
            try self.read()
        }catch let error {
            print("Could not read from defaults. \(error.localizedDescription)")
            self.readJSONFile(from: "packageList")
        }
        //self.readJSONFile(from: "packageList")
        
    }
    
    func readJSONFile(from url: String) {
        if let path = Bundle.main.path(forResource: url, ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.allPackages = try JSONDecoder().decode(PackageList.self, from: data).packages
                self.currentSortOption = .data
            }
            catch let error {
                print("Error occured")
                print(error)
            }
        }else{
            print("data not found")
        }
    }
}


extension PackagesViewModel {
    
    func changeFavorite(for package: PackageList.Package) {
        self.allPackages = self.allPackages.map({
            var mutablePackage = $0
            if $0.id == package.id {
                mutablePackage.isFavorite.toggle()
            }
            return mutablePackage
        })
        self.sort()
        self.filter()
    }
    
    func sort() {
        self.allPackages = self.allPackages.sorted(by: { (first, second) -> Bool in
            if first.isFavorite != second.isFavorite {
               return first.isFavorite && !second.isFavorite
            }else if first.subscriptionType != second.subscriptionType {
                return first.subscriptionType < second.subscriptionType
            }else{
                switch self.currentSortOption {
                case .data:
                    return Int(first.tariff.data)! > Int(second.tariff.data)!
                case .sms:
                    return Int(first.tariff.sms)! > Int(second.tariff.sms)!
                case .talk:
                    return Int(first.tariff.talk)! > Int(second.tariff.talk)!
                }
            }
        })
    }

    func filter() {
        print(self.allPackages.count)
        var packagesToBeFiltered = self.allPackages
        for option in self.currentFilterOptions.getFilters() {
            switch option {
            case .byKeyword(keyword: let keyword):
                packagesToBeFiltered = packagesToBeFiltered.filter({ package in
                    return package.name.contains(keyword)
                })
            case .byPrice(from: let from, to: let to):
                packagesToBeFiltered = packagesToBeFiltered.filter({ package in
                    return from <= package.price && package.price <= to
                })
            case .none:
                break
            }
        }
        self.filteredPackages = packagesToBeFiltered
    }
}

extension PackagesViewModel {
    func write() throws {
        print("writing")
        if let encoded = try? self.encoder.encode(self.allPackages) {
            print("succesfully written")
            self.defaults.set(encoded, forKey: "packages")
        }else {
            throw DefaultsError.writingError
        }
   }
       
   func read() throws {
    print("reading")
       if let packages = defaults.object(forKey: "packages") as? Data {
           print("successfully read")
           self.allPackages = try self.decoder.decode([PackageList.Package].self, from: packages)
           self.sort()
       }else {
           throw DefaultsError.readingError
       }
   }
}

enum DefaultsError: Error {
    case writingError
    case readingError
}


