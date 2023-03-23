//
//  FlowCoordinator.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 22.03.23.
//

import Foundation

/// A `FlowCoordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol FlowCoordinator: AnyObject {

    /// Stars the flow
    func start()
}
