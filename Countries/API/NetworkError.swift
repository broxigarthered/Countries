//
//  NetworkError.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 20.03.23.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case invalidURL
    case invalidServerData
    case invalidResponse
    case invalidDecoding(error: String)
    case generic(message: String)
}

extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .error(let statusCode, _):
            return("Fetching data from server failed with status code \(statusCode)")
        case .notConnected:
            return("Could not connect to server. No internet connection.")
        case .invalidURL:
            return ("The url was invalid.")
        case .invalidServerData:
            return "Couldn't load data from server."
        case .invalidResponse:
            return ("Invalid response.")
        case .invalidDecoding(let error):
            return ("There was a problem parsing the json data - \(error)")
        case .generic(let message):
            return ("An error occured: \(message)")
        }
    }
}
