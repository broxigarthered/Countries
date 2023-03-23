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
    func didSearch(country name: String)
    func didCancelSearching()
}

class CountriesViewModel {
    
    private let countriesService: CountriesService
    private weak var navigator: CountriesNavigator?
    lazy var isLoading: Observable<Bool> = Observable(false)
    lazy var countries: Observable<[Country]> = Observable([])
    lazy var error: Observable<String> = Observable("")
    private lazy var filteredCountries: Observable<[Country]> = Observable([])
    private lazy var initialCountries: Observable<[Country]> = Observable([])
    
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
                self?.initialCountries.value = self?.countries.value ?? []
            case .failure(let error):
                self?.error.value = error.description
            }
        }
    }
    
    func didSearch(country name: String) {
        guard name.count >= 3 else {
            // todo: countries.value = the initial state
            //            filteredCountries.value = countries.value
            countries.value = initialCountries.value
            print(countries.value.count)
            return
        }
        
        filteredCountries.value = countries.value.filter { country in
            country.name.contains(name)
        }
        
        countries.value = filteredCountries.value
        print(countries.value.count)
    }
    
    func didCancelSearching() {
        countries.value = initialCountries.value
    }
    
}
