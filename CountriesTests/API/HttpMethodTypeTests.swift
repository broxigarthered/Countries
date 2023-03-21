//
//  HttpMethodTypeTests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import XCTest
@testable import Countries

final class HttpMethodTypeTests: XCTestCase {
    
    func testNetworkErrorDescription() {
        XCTAssertEqual(HttpMethodType.get.rawValue, "GET")
        XCTAssertEqual(HttpMethodType.post.rawValue, "POST")
    }
    
}
