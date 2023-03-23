//
//  ApplicationFlowCoordinatorTests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 23.03.23.
//

import XCTest
@testable import Countries

class ApplicationFlowCoordinatorDependencyProviderMock: ApplicationCoordinatorDependencyProvider {
    
    var mockCountriesNavigationController: UINavigationController?
    func makeCountriesNavigationController(navigator: Countries.CountriesNavigator) -> UINavigationController {
        return mockCountriesNavigationController!
    }
    
    var mockCountryDetailsViewController: UIViewController?
    func makeCountryDetailsController(_ country: Countries.Country) -> UIViewController {
        return mockCountryDetailsViewController!
    }
    
}

final class ApplicationFlowCoordinatorTests: XCTestCase {
    
    private var flowCoordinator: ApplicationFlowCoordinator!
    private var window: UIWindow!
    private var dependencyProvider: ApplicationFlowCoordinatorDependencyProviderMock!
    
    override func setUpWithError() throws {
        
        window = UIWindow()
        dependencyProvider = ApplicationFlowCoordinatorDependencyProviderMock()
        flowCoordinator = ApplicationFlowCoordinator(window: window,
                                                     dependencyProvider: dependencyProvider)
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        flowCoordinator = nil
        window = nil
        dependencyProvider = nil
        
        try super.tearDownWithError()
    }
    
    /// Test that application flow is started correctly
    func test_startsApplicationsFlow() {
        // Given
        let rootViewController = UINavigationController()
        dependencyProvider.mockCountriesNavigationController = rootViewController
        
        // When
        flowCoordinator.start()
        
        // Then
        XCTAssertEqual(window.rootViewController, rootViewController)
    }
    
}
