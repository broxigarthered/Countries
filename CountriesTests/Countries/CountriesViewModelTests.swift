//
//  CountriesViewModelTests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import XCTest
@testable import Countries

class CountriesServiceMock: CountriesService {
    
    var mockData: [Country]?
    var mockError: NetworkError?
    
    func getCountries(completion: @escaping (Result<[Countries.Country], Countries.NetworkError>) -> Void) {
        if let mockData = mockData {
            completion(.success(mockData))
        }
        
        if let mockError = mockError {
            completion(.failure(mockError))
        }
    }
    
}

class CountriesNavigatorMock: CountriesNavigator {
    
    var showDetailsCallCount = 0
    var receivedCountry: Country?
    
    func showDetails(for country: Countries.Country) {
        showDetailsCallCount += 1
        receivedCountry = country
    }
    
}

struct CountriesMock {
    
    static func generateCountries() -> [Country] {
        let country1 = Country(capitalName: "Sofia",
                               code: "1574",
                               flag: "https://bulgarian-flag.com",
                               latLng: [111.0, 111.0],
                               name: "Bulgaria",
                               population: 6800000,
                               region: "Southeastern Europe",
                               subregion: "random")
        let country2 = Country(capitalName: "London",
                               code: "2222",
                               flag: "https://uk-flag.com",
                               latLng: [111.0, 111.0],
                               name: "United Kingdom",
                               population: 120000000,
                               region: "Europe",
                               subregion: "random")
        let country3 = Country(capitalName: "Dhaka",
                               code: "1111",
                               flag: "https://bangladesh-flag.com",
                               latLng: [111.0, 111.0],
                               name: "Bangladesh",
                               population: 15000,
                               region: "Southeastern Europe",
                               subregion: "random")
        
        return [country1, country2, country3]
    }
    
}

final class CountriesViewModelTests: XCTestCase {
    
    var countriesService: CountriesServiceMock!
    var countriesNavigator: CountriesNavigatorMock!
    var sut: CountriesViewModel!
    
    override func setUpWithError() throws {
        countriesService = CountriesServiceMock()
        countriesNavigator = CountriesNavigatorMock()
        sut = CountriesViewModel(apiService: countriesService,
                                 navigator: countriesNavigator)
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        countriesService = nil
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func testViewDidLoad_loading() {
        // Given
        let expect = expectation(description: "Loading")
        sut.isLoading.observe(on: self, observerBlock: { isLoading in
            if !isLoading {
                expect.fulfill()
            }
        })
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expect], timeout: 1.0)
        XCTAssertTrue(sut.isLoading.value)
    }
    
    func testViewDidLoad_success() {
        // Given
        let expect = expectation(description: "Fetch Success")
        countriesService.mockData = CountriesMock.generateCountries()
        
        sut.countries.observe(on: self) { countries in
            if !countries.isEmpty {
                expect.fulfill()
            }
        }
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expect], timeout: 1.0)
        XCTAssertFalse(sut.isLoading.value)
        XCTAssertEqual(sut.countries.value.count, 3)
        // countries are being sorted by population in descending order
        XCTAssertEqual(sut.countries.value[0].name, "United Kingdom")
        XCTAssertEqual(sut.countries.value[1].name, "Bulgaria")
        XCTAssertEqual(sut.countries.value[2].name, "Bangladesh")
    }
    
    func testViewDidLoad_failure() {
        // Given
        let expect = expectation(description: "Fetch Failure")
        countriesService.mockError = .invalidResponse
        sut.error.observe(on: self, observerBlock: { error in
            if !error.isEmpty {
                expect.fulfill()
            }
        })
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expect], timeout: 1.0)
        XCTAssertFalse(sut.isLoading.value)
        XCTAssertEqual(sut.error.value, NetworkError.invalidResponse.description)
    }
    
    func testDidSelectCountry() {
        // Given
        let countryMock = Country(capitalName: "Sofia",
                                  code: "1574",
                                  flag: "https://bulgarian-flag.com",
                                  latLng: [111.0, 111.0],
                                  name: "Bulgaria",
                                  population: 6800000,
                                  region: "Southeastern Europe",
                                  subregion: "random")
        
        //When
        sut.didSelectCountry(country: countryMock)
        
        // Then
        XCTAssertEqual(countriesNavigator.showDetailsCallCount, 1)
        XCTAssertNotNil(countriesNavigator.receivedCountry)
        XCTAssertEqual(countriesNavigator.receivedCountry?.capitalName, countryMock.capitalName)
        XCTAssertEqual(countriesNavigator.receivedCountry?.code, countryMock.code)
        XCTAssertEqual(countriesNavigator.receivedCountry?.flag, countryMock.flag)
        XCTAssertEqual(countriesNavigator.receivedCountry?.name, countryMock.name)
        XCTAssertEqual(countriesNavigator.receivedCountry?.population, countryMock.population)
    }
    
    func testDidSearch_with_validInput_shouldReturnOneCountry() {
        // Given
        countriesService.mockData = CountriesMock.generateCountries()
        
        // When
        sut.viewDidLoad()
        sut.didSearch(country: "Bulg")
        
        // Then
        XCTAssertEqual(sut.countries.value.count, 1)
        XCTAssertEqual(sut.countries.value[0].name, "Bulgaria")
    }
    
    func testDidSearch_with_validInput_lowercaseAndCapitalCharacters_shouldReturnOneCountry() {
        // Given
        countriesService.mockData = CountriesMock.generateCountries()
        
        // When
        sut.viewDidLoad()
        sut.didSearch(country: "buLG")
        
        // Then
        XCTAssertEqual(sut.countries.value.count, 1)
        XCTAssertEqual(sut.countries.value[0].name, "Bulgaria")
    }
    
    func testDidSearch_with_lessThanThree_characters_shouldReturnSameCountries() {
        // Given
        countriesService.mockData = CountriesMock.generateCountries()
        
        // When
        sut.viewDidLoad()
        sut.didSearch(country: "B")
        
        // Then
        XCTAssertEqual(sut.countries.value.count, 3)
    }
    
    func testDidSearch_with_moreThanThree_characters_shouldReturnZero_countries() {
        // Given
        countriesService.mockData = CountriesMock.generateCountries()
        
        // When
        sut.viewDidLoad()
        sut.didSearch(country: "Bulglgekgeoogek")
        
        // Then
        XCTAssertEqual(sut.countries.value.count, 0)
    }
    
    func testDidSearch_withMultiple_searches() {
        countriesService.mockData = CountriesMock.generateCountries()
        sut.viewDidLoad()
        
        sut.didSearch(country: "Bang")
        XCTAssertEqual(sut.countries.value.count, 1)
        XCTAssertEqual(sut.countries.value[0].name, "Bangladesh")
        
        sut.didSearch(country: "A")
        XCTAssertEqual(sut.countries.value.count, 3)
        
        sut.didSearch(country: "Unit")
        XCTAssertEqual(sut.countries.value.count, 1)
        XCTAssertEqual(sut.countries.value[0].name, "United Kingdom")
        
        sut.didSearch(country: "randomrandom")
        XCTAssertEqual(sut.countries.value.count, 0)
    }
    
    func testCancelSearch_shouldReturn_original_Count() {
        // Given
        countriesService.mockData = CountriesMock.generateCountries()
        
        // When
        sut.viewDidLoad()
        sut.didSearch(country: "Bulg")
        
        // Then
        XCTAssertEqual(sut.countries.value.count, 1)
        
        sut.didCancelSearching()
        XCTAssertEqual(sut.countries.value.count, 3)
    }
}
