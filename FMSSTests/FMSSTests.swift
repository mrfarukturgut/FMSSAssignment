//
//  FMSSTests.swift
//  FMSSTests
//
//  Created by Faruk Turgut on 19.02.2020.
//  Copyright © 2020 Faruk Turgut. All rights reserved.
//

import XCTest
@testable import FMSS

//Favorileri, Favorilerin sort edilmesi,

class FMSSTests: XCTestCase{
    
    let viewModel: PackagesViewModel = PackagesViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel.sort()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCountOfFilteredPackages() {
        viewModel.currentFilterOptions = Options.FilterOptions(byPrice: .byPrice(from: 100, to: 200), byKeyword: .none)
        let actualCount = viewModel.filteredPackages.count
        let expectedCount = 3
        XCTAssertEqual(expectedCount, actualCount)
    }
    
    func testRemoveFromFavorites() {
        let package = viewModel.filteredPackages.first!
        XCTAssertTrue(package.isFavorite)
        viewModel.changeFavorite(for: package)
        let editedPackage: PackageList.Package = self.getPackage(by: package)
        XCTAssertFalse(editedPackage.isFavorite)
    }
    
    func testAddToFavorites() {
        let package = viewModel.filteredPackages.last!
        XCTAssertFalse(package.isFavorite)
        viewModel.changeFavorite(for: package)
        let editedPackage: PackageList.Package = self.getPackage(by: package)
        XCTAssertTrue(editedPackage.isFavorite)
    }
    
    func testFavouriteSort(){
        viewModel.sort()
        let favoriteValues = viewModel.filteredPackages.map { $0.isFavorite }
        for idx in 0...favoriteValues.count-2 {
            XCTAssertGreaterThanOrEqual(favoriteValues[idx].intValue, favoriteValues[idx+1].intValue)
        }
    }
    
    func testKeywordFilter(){
        let keyword = "Akıllı"
        viewModel.currentFilterOptions = .init(byPrice: .none, byKeyword: .byKeyword(keyword: keyword))
        for package in viewModel.filteredPackages {
            XCTAssert(package.name.contains(keyword))
        }
    }
    
    func testPriceFilter(){
        let fromPrice: Float = 50
        let toPrice: Float = 100
        viewModel.currentFilterOptions = .init(byPrice: .byPrice(from: fromPrice, to: toPrice), byKeyword: .none)
        for package in viewModel.filteredPackages {
            XCTAssertGreaterThanOrEqual(package.price, fromPrice)
            XCTAssertLessThanOrEqual(package.price, toPrice)
        }
    }
    
    func testSubscriptionTypeSort(){
        self.viewModel.currentFilterOptions = .init(byPrice: .none, byKeyword: .none)
        self.viewModel.currentSortOption = .sms
        let favoritePackages = self.viewModel.filteredPackages.filter({ $0.isFavorite == true })
        let nonFavoritePackages = self.viewModel.filteredPackages.filter({ $0.isFavorite == false})
        for idx in 1...favoritePackages.count-1 {
            XCTAssertGreaterThanOrEqual(favoritePackages[idx].subscriptionType.priority, favoritePackages[idx-1].subscriptionType.priority)
        }
        for idx in 1...nonFavoritePackages.count-1 {
            XCTAssertGreaterThanOrEqual(nonFavoritePackages[idx].subscriptionType.priority, nonFavoritePackages[idx-1].subscriptionType.priority)
        }
    }
    
    private func getPackage(by package: PackageList.Package) -> PackageList.Package {
        return viewModel.filteredPackages.filter({$0.id == package.id}).first!
    }
    
    private func getFavoritePackages() -> [PackageList.Package] {
        return viewModel.filteredPackages.filter({ $0.isFavorite })
    }
    
}
