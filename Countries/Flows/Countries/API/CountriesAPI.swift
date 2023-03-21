//
//  CountriesAPI.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 20.03.23.
//

import Foundation

protocol CountriesService {
    func getCountries(completion: @escaping (Result<[Country], NetworkError>) -> Void)
}

class CountriesAPI: CountriesService {

    private let httpClient: NetworkManager?
    
    init(httpClient: NetworkManager) {
        self.httpClient = httpClient
    }
     
    func getCountries(completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        let endpoint = Endpoint(endpoint: ApiConstants.Countries.countries)
        
        httpClient?.request(endpoint: endpoint, completion: { result in
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
    
}
