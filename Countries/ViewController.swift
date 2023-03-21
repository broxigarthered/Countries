//
//  ViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let session = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: session)
        let countriesService = CountriesAPI(httpClient: httpClient)
//        countriesService.getCountries { result in
//            switch result {
//            case .success(let success):
//                print("UDRI bache \(success)")
//            case .failure(let failure):
//                print(failure)
//            }
//        }
        
        countriesService.getCountries { result in
            switch result {
            case .success(let success):
                print("Success - \(success)")
            case .failure(let failure):
                print(failure)
            }
        }
    }


}

