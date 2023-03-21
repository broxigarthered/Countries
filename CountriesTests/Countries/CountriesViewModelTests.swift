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

final class CountriesViewModelTests: XCTestCase {
    
    var countriesService: CountriesServiceMock!
    var sut: CountriesViewModel!

    override func setUpWithError() throws {
        countriesService = CountriesServiceMock()
        sut = CountriesViewModel(apiService: countriesService)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        countriesService = nil
        sut = nil
        
        try super.tearDownWithError()
    }

    func test_viewDidLoad_loading() {
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
    
    func test_viewDidLoad_success() {
        // Given
        let expect = expectation(description: "Fetch Success")
        countriesService.mockData = [
            Country(capitalName: "capital1",
                    code: "code1",
                    flag: "flag.url",
                    latLng: [33.0,33.0],
                    name: "Bulgaria",
                    population: 1,
                    region: "region1",
                    subregion: "subregion1")
        ]
        
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
        XCTAssertEqual(sut.countries.value.count, 1)
        XCTAssertEqual(sut.countries.value.first?.name, "Bulgaria")
    }
    
    func test_viewDidLoad_failure() {
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
    
}
