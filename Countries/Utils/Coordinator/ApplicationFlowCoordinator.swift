//
//  ApplicationFlowCoordinator.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 22.03.23.
//

import UIKit

class ApplicationFlowCoordinator: FlowCoordinator {
    
    typealias DependencyProvider = ApplicationCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()
    
    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    /// Creates all necessary dependencies and starts the flow
    func start() {
        let countriesFlowCoordinator = CountriesFlowCoordinator(window: window,
                                                                dependencyProvider: dependencyProvider)
        childCoordinators = [countriesFlowCoordinator]
        countriesFlowCoordinator.start()
    }
    
}
