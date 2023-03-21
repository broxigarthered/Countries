//
//  EndpointTests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import XCTest
@testable import Countries

final class EndpointTests: XCTestCase {
    
    func testEndpointInitialization() {
        let endpoint = Endpoint(endpoint: "countries")
        XCTAssertEqual(endpoint.endpoint, "countries")
        XCTAssertEqual(endpoint.baseUrl, ApiConstants.baseUrl)
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.headerParameters, [:])
        XCTAssertEqual(endpoint.timeoutInterval, 2.0)
    }
    
    func testEndpointInitializationWithCustomValues() {
        let endpoint = Endpoint(endpoint: "user/profile",
                                baseUrl: "https://test.example.com",
                                method: .post,
                                headerParameters: ["Authorization": "Bearer token"],
                                timeoutInterval: 5.0)
        XCTAssertEqual(endpoint.endpoint, "user/profile")
        XCTAssertEqual(endpoint.baseUrl, "https://test.example.com")
        XCTAssertEqual(endpoint.method, .post)
        XCTAssertEqual(endpoint.headerParameters, ["Authorization": "Bearer token"])
        XCTAssertEqual(endpoint.timeoutInterval, 5.0)
    }
    
}
