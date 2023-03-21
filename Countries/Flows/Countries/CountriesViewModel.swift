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
                print("Success - \(countries)")
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
}
