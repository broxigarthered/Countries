//
//  ViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sampleLabel: UILabel!
    
    var viewModel: CountriesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let session = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: session)
        let countriesService = CountriesAPI(httpClient: httpClient)
        
        viewModel = CountriesViewModel(apiService: countriesService)
        
        viewModel?.viewDidLoad()
        viewModel?.isLoading.observe(on: self) { value in
            value == true ? LoadingView.show() : LoadingView.hide()
        }
        
        viewModel?.countries.observe(on: self, observerBlock: { countries in
            for country in countries {
                print(country.population)
                print(country.flag)
            }
        })
        
    }

}


