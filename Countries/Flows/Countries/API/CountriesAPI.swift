//
//  CountriesAPI.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 20.03.23.
//

import Foundation

protocol CountriesService {
    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void)
    func testGetCountries(completion: @escaping (Result<[Country], NetworkError>) -> Void)
}

class CountriesAPI: CountriesService {
    func testGetCountries(completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        let endpoint = Endpoint(endpoint: ApiConstants.Countries.countries)
        
        httpClient?.secondRequest(endpoint: endpoint, completion: { result in
            switch result {
            case .success(let data):
                do {
                    let countries = try JSONDecoder().decode([Country].self, from: data)
                    completion(.success(countries))
                } catch {
                    completion(.failure(NetworkError.invalidDecoding(error: String(describing: error))))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private let httpClient: NetworkManager?
    
    init(httpClient: NetworkManager) {
        self.httpClient = httpClient
    }
    
    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void) {

        let endpoint = Endpoint(endpoint: ApiConstants.Countries.countries)
        
        httpClient?.request(endpoint: endpoint) { data, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
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
