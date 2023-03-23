//
//  ApplicationCoordinatorDependencyProvider.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 23.03.23.
//

import UIKit

/// The `ApplicationCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationCoordinatorDependencyProvider: CountriesFlowCoordinatorDependencyProvider {}

protocol CountriesFlowCoordinatorDependencyProvider: AnyObject {
    /// Creates UIViewController to search for a movie
    func makeCountriesNavigationController(navigator: CountriesNavigator) -> UINavigationController

    // Creates UIViewController to show the details of the country
    func makeCountryDetailsController(_ country: Country) -> UIViewController
}
