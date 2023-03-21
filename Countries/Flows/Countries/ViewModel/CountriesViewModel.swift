//
//  CountriesViewModel.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import Foundation


protocol CountriesViewModelInput {
    func viewDidLoad()
}

class CountriesViewModel {
    
    private let countriesService: CountriesService
    let isLoading: Observable<Bool> = Observable(false)
    let countries: Observable<[Country]> = Observable([])
    let error: Observable<String> = Observable("")
    
    init(apiService: CountriesService) {
        countriesService = apiService
    }
    
}

extension CountriesViewModel: CountriesViewModelInput {
    
    func viewDidLoad() {
        isLoading.value = true
        countriesService.getCountries { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let countries):
                self?.countries.value = countries.sorted(by: { c1, c2 in
                    c1.population > c2.population
                })
            case .failure(let error):
                self?.error.value = error.description
            }
        }
    }
    
    
}
