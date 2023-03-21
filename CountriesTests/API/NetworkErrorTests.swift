//
//  NetworkErrorTests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import XCTest
@testable import Countries

final class NetworkErrorTests: XCTestCase {
    
    func testNetworkErrorDescription() {
        XCTAssertEqual(NetworkError.error(statusCode: 404, data: nil).description, "Fetching data from server failed with status code 404")
        XCTAssertEqual(NetworkError.notConnected.description, "Could not connect to server. No internet connection.")
        XCTAssertEqual(NetworkError.invalidURL.description, "The url was invalid.")
        XCTAssertEqual(NetworkError.invalidServerData.description, "Couldn't load data from server.")
        XCTAssertEqual(NetworkError.invalidResponse.description, "Invalid response.")
        XCTAssertEqual(NetworkError.invalidDecoding(error: "missing field").description, "There was a problem parsing the json data - missing field")
        XCTAssertEqual(NetworkError.generic(message: "An error occurred").description, "An error occured: An error occurred")
    }
    
}
