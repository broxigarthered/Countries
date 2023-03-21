//
//  ViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import UIKit

class CountriesViewController: UIViewController {
    
    // TODO: this won't be optional after an coordinator is implemented
    var viewModel: CountriesViewModel?
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
            titleLabel.numberOfLines = 0
            titleLabel.text = "World countries list\n🇧🇬🇩🇪🇺🇸🇦🇩"
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 1.0
            tableView.rowHeight = UITableView.automaticDimension
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerNib(cellClass: CountryTableViewCell.self)
        }
    }
    
    
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
        
        viewModel?.countries.observe(on: self, observerBlock: { [weak self] countries in
            self?.tableView.reloadData()
        })
        
    }

}

// MARK: UITableViewDataSource & UITableViewDelegate

extension CountriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withClass: CountryTableViewCell.self) else {
            assertionFailure("Failed to dequeue \(CountryTableViewCell.self)!")
            return UITableViewCell()
        }
        
        if let model = viewModel?.countries.value[indexPath.row] {
            cell.update(with: model.name)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countries.value.count ?? 0
    }
    
}

extension CountriesViewController: UITableViewDelegate {
    
}


