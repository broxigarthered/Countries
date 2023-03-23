//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 23.03.23.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    private let viewModel: CountryDetailsViewModel
    
    init(viewModel: CountryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Country Details"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
