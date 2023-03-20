//
//  NetworkManagerTests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import XCTest
@testable import Countries

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func errorHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        
        if let nextData = nextData {
            completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        }
        
        if let nextError = nextError {
            completionHandler(nextData, errorHttpURLResponse(request: request), nextError )
        }
        
        return nextDataTask
    }
    
}

final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    let session = MockURLSession()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkManager = NetworkManager(session: session)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testGetRequest_withUrl() {
        
        guard let url = URL(string: "https://mockurl/mockUrlEndpoint") else {
            fatalError("URL can't be empty")
        }
        let endpoint = Endpoint(endpoint: "/mockUrlEndpoint", baseUrl: "https://mockurl", method: .get)
        
        networkManager.secondRequest(endpoint: endpoint) { result in
            // result
        }
        
        XCTAssert(session.lastURL == url)
    }
    
    func testPostRequest_withUrl() {
        
        guard let url = URL(string: "https://mockurl/mockUrlEndpoint") else {
            fatalError("URL can't be empty")
        }
        let endpoint = Endpoint(endpoint: "/mockUrlEndpoint", baseUrl: "https://mockurl", method: .post)
        
        networkManager.secondRequest(endpoint: endpoint) { result in
            // result
        }
        
        XCTAssert(session.lastURL == url)
    }
    
    
    func testRequest_resumeWasCalled() {
        
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        let endpoint = Endpoint(endpoint: "/mockUrlEndpoint", baseUrl: "https://mockurl", method: .post)
        networkManager.secondRequest(endpoint: endpoint) { result in
            
        }
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testGetRequest_should_returnData() {
        let expectedData = "{}".data(using: .utf8)
        
        session.nextData = expectedData
        
        var actualData: Data?
        
        let endpoint = Endpoint(endpoint: "/mockUrlEndpoint", baseUrl: "https://mockurl", method: .post)
        networkManager.secondRequest(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure( _):
                XCTFail("There should be no error")
            }
        }

        XCTAssertNotNil(actualData)
    }
    
    func testGetRequest_should_returnError() {
        session.nextError = NetworkError.generic(message: "Sample error")
        var actualError: Error?
        
        let endpoint = Endpoint(endpoint: "/mockUrlEndpoint", baseUrl: "https://mockurl", method: .post)
        networkManager.secondRequest(endpoint: endpoint) { result in
            switch result {
            case .success( _):
                XCTFail("There should be no data")
            case .failure(let error):
                actualError = error
            }
        }
        
        XCTAssertNotNil(actualError)
    }
    
}
