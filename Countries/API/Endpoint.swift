//
//  Endpoint.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 20.03.23.
//

import Foundation

public struct Endpoint {
    public let endpoint: String
    public let baseUrl: String
    public let method: HttpMethodType
    public let headerParameters: [String: String]
    public let timeoutInterval: Double
    
    init(endpoint: String,
         baseUrl: String = ApiConstants.baseUrl,
         method: HttpMethodType = .get,
         headerParameters: [String: String] = [:],
         timeoutInterval: Double = 2.0) {
        self.endpoint = endpoint
        self.baseUrl = baseUrl
        self.method = method
        self.headerParameters = headerParameters
        self.timeoutInterval = timeoutInterval
    }
}
