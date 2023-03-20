//
//  NetworkManager.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import Foundation



// TODO: Stay to this file but do some refactoring

// MARK: - Data task protocol
protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

class HttpClient {
    
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void

    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(url: URL, callback: @escaping completeClosure) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, error)
        }
        task.resume()
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


// MARK: Countries API - move to other file - CountriesAPI

// MARK: - Countries Service
protocol CountriesService {
    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void)
}

class CountriesAPI: CountriesService {
    
    private let httpClient: HttpClient?
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        let session = URLSession(configuration: .default)
        let client = HttpClient(session: session)
        // TODO: Extract this url to an enum
        let url = URL(string: "https://excitel-countries.azurewebsites.net/countries")!
        
        client.get(url: url) { data, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                // TODO: decode it to a response
                do {
                    let countries = try JSONDecoder().decode([Country].self, from: data)
                    print(countries)
                    completion(.success(countries))
                } catch {
                    print("Error while decoding Country object \(error.localizedDescription)")
                    print(String(describing: error))
                }
            }
        }
    }
    
}

struct Country: Decodable {
    let capitalName: String
    let code: String
    let flag: String
    let latLng: [Double]
    let name: String
    let population: Int
    let region: String
    let subregion: String
}


//class APIManager: UserService {
//
//    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
//
//        let url = URL(string: "https://reqres.in/api/users/2")!
//
//        URLSession.shared.dataTask(with: url) { data, res, error in
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                if let user = try? JSONDecoder().decode(UserResponse.self, from: data).data {
//                    completion(.success(user))
//                } else {
//                    completion(.failure(NSError()))
//                }
//            }
//        }.resume()
//    }
//}


