//
//  CountriesViewModel.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import Foundation


protocol CountriesViewModelInput {
    func viewDidLoad()
    func didSelectCountry(country: Country)
}

class CountriesViewModel {
    
    private let countriesService: CountriesService
    private weak var navigator: CountriesNavigator?
    let isLoading: Observable<Bool> = Observable(false)
    let countries: Observable<[Country]> = Observable([])
    let error: Observable<String> = Observable("")
    
    init(apiService: CountriesService, navigator: CountriesNavigator) {
        countriesService = apiService
        self.navigator = navigator
    }
    
}

extension CountriesViewModel: CountriesViewModelInput {
    func didSelectCountry(country: Country) {
        navigator?.showDetails(for: country)
    }
    
    
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
