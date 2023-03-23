//
//  CountriesAPITests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import XCTest
@testable import Countries

class MockNetworkManager: HttpRequestable {
    
    var mockData: Data?
    var mockError: NetworkError?
    
    func request(endpoint: Countries.Endpoint, completion: @escaping Completion) {
        if let data = mockData {
            completion(.success(data))
        }
        
        if let error = mockError {
            completion(.failure(error))
        }
    }
    
}

final class CountriesAPITests: XCTestCase {
    
    var countriesApi: CountriesService!
    var networkManager: MockNetworkManager!

    override func setUpWithError() throws {
        networkManager = MockNetworkManager()
        countriesApi = CountriesAPI(httpClient: networkManager)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        networkManager = nil
        countriesApi = nil
        
        try super.tearDownWithError()
    }
    
    func testGetCountries_Success() {
        // Given
        networkManager.mockData =  """
        [
            {
                "capitalName":"Kabul",
                "code":"AFG",
                "flag":"https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_the_Taliban.svg",
                "latLng":[33.0,65.0],
                "name":"Afghanistan",
                "population":40218234,
                "region":"Asia",
                "subregion":"Southern Asia"
            },
            {
                "capitalName":"Mariehamn",
                "code":"ALA",
                "flag":"https://flagcdn.com/ax.svg",
                "latLng":[60.116667,19.9],
                "name":"Åland Islands",
                "population":28875,
                "region":"Europe",
                "subregion":"Northern Europe"
            }
        ]
        """.data(using: .utf8)!
        
        let expectation = self.expectation(description: "getCountries")
        
        // When
        countriesApi.getCountries { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.count, 2)
                XCTAssertEqual(data[0].name, "Afghanistan")
                XCTAssertEqual(data[0].capitalName, "Kabul")
                XCTAssertEqual(data[0].code, "AFG")
                XCTAssertEqual(data[0].flag, "https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_the_Taliban.svg")
                XCTAssertEqual(data[0].latLng, [33.0,65.0])
                XCTAssertEqual(data[0].population, 40218234)
                XCTAssertEqual(data[0].region, "Asia")
                XCTAssertEqual(data[0].subregion, "Southern Asia")
                
                XCTAssertEqual(data[1].name, "Åland Islands")
                XCTAssertEqual(data[1].capitalName, "Mariehamn")
                XCTAssertEqual(data[1].code, "ALA")
                XCTAssertEqual(data[1].flag, "https://flagcdn.com/ax.svg")
                XCTAssertEqual(data[1].latLng, [60.116667,19.9])
                XCTAssertEqual(data[1].population, 28875)
                XCTAssertEqual(data[1].region, "Europe")
                XCTAssertEqual(data[1].subregion, "Northern Europe")
            case .failure(let error):
                XCTFail("Expected success, got error \(error)")
            }
            
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
    }
    
    func testGetCountries_Error() {
        // Given
        networkManager.mockError = NetworkError.error(statusCode: 404, data: nil)
        let expectation = self.expectation(description: "getCountries")
        let expectedError = NetworkError.error(statusCode: 404, data: nil)
        
        // When
        countriesApi.getCountries { result in
            switch result {
            case .success(let data):
                XCTFail("Expected failure, got success \(data)")
            case .failure(let error):
                XCTAssertEqual(error.description, expectedError.description)
            }
            
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
    }
    
    func testGetCountries_ParseError() {
        // Given
        networkManager.mockData =  """
        [
            {
                "capitalName":"Kabul",
                "code":"AFG",
                "flag":"https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_the_Taliban.svg",
                "latLng":[33.0,65.0],
                "name":"Afghanistan",
                "population":"RANDOMSTRING",
                "region":"Asia",
                "subregion":"Southern Asia"
            }
        ]
        """.data(using: .utf8)!
        
        let expectation = self.expectation(description: "getCountries")
        let expectedError = NetworkError.invalidDecoding(error: "").description

        // When
        countriesApi.getCountries { result in
            switch result {
            case .success(let data):
                XCTFail("Expected failure, got success \(data)")
            case .failure(let error):
                XCTAssertEqual(error.description, expectedError)
            }
            
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
    }

}
