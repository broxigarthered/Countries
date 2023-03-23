//
//  ApplicationComponentsFactory.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 23.03.23.
//

import UIKit

// Provides dependencies needed by the controllers
final class ApplicationComponentsFactory: ApplicationCoordinatorDependencyProvider {
    
    func makeCountriesNavigationController(navigator: CountriesNavigator) -> UINavigationController {
        let session = URLSession(configuration: .default)
        let networkManager = NetworkManager(session: session)
        let countriesApi = CountriesAPI(httpClient: networkManager)
        let viewModel = CountriesViewModel(apiService: countriesApi, navigator: navigator)
        let viewController = CountriesViewController(viewModel: viewModel)
        let countriesNavigationController = UINavigationController(rootViewController: viewController)
        return countriesNavigationController
    }
    
    func makeCountryDetailsController(_ country: Country) -> UIViewController {
        let viewModel = CountryDetailsViewModel(country: country)
        let imageCache: ImageCacheType = ImageCache()
        let viewController = CountryDetailsViewController(viewModel: viewModel, imageCache: imageCache)
        return viewController
    }
    
}
