//
//  CountriesFlowCoordinator.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 22.03.23.
//

import UIKit

protocol CountriesNavigator: AnyObject {
    /// Presents the country details screen
    func showDetails(for country: Country)
}

/// The `CountriesFlowCoordinator` takes control over the flows on the countries and country details navigation
class CountriesFlowCoordinator: FlowCoordinator, CountriesNavigator {
    
    fileprivate let window: UIWindow
    fileprivate var navigationController: UINavigationController?
    fileprivate let dependencyProvider: CountriesFlowCoordinatorDependencyProvider

    init(window: UIWindow, dependencyProvider: CountriesFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let navigationController = dependencyProvider.makeCountriesNavigationController(navigator: self)
        window.rootViewController = navigationController
        self.navigationController = navigationController
    }
    
    func showDetails(for country: Country) {
        let controller = self.dependencyProvider.makeCountryDetailsController(country)
        navigationController?.pushViewController(controller, animated: true)
    }
}
