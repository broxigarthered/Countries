//
//  NetworkManager.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import Foundation

// MARK: - Data task protocol
protocol URLSessionDataTaskProtocol {
    
    func resume()
    
}

protocol URLSessionProtocol {
    
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    
}

protocol HttpRequestable {
    
    typealias Completion = (_ result: Result<Data, NetworkError>) -> Void
    
    func request(endpoint: Endpoint, completion: @escaping Completion)
    
}

class NetworkManager: HttpRequestable {
    func request(endpoint: Endpoint, completion: @escaping Completion) {
        guard let url = URL(string: endpoint.baseUrl + endpoint.endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard 200..<300 ~= response.statusCode else {
                completion(.failure(NetworkError.error(statusCode: response.statusCode, data: data)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.invalidServerData))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
    }

    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }

}

//MARK: Protocol Conform
/// URLSession and URLSessionDataTask both comform to our protocols so they can be mocked for unit tests
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
