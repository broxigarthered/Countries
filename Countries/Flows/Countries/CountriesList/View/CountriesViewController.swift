//
//  ViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import UIKit

class CountriesViewController: UIViewController {
    
    private struct Constants {
        public static let searchTextFieldId = "\(CountriesViewController.self).searchTextFieldId"
    }

    var viewModel: CountriesViewModel
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
            titleLabel.numberOfLines = 0
            titleLabel.text = "\n🇧🇬🇩🇪🇺🇸🇦🇩"
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
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.accessibilityIdentifier = Constants.searchTextFieldId
        searchController.searchBar.placeholder = "Enter at least 3 characters"
        return searchController
    }()
    
    init(viewModel: CountriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
        bind(to: viewModel)
        configureUI()
        
    }
    
    private func bind(to viewModel: CountriesViewModel?) {
        viewModel?.isLoading.observe(on: self) { value in
            value == true ? LoadingView.show() : LoadingView.hide()
        }
        
        viewModel?.countries.observe(on: self, observerBlock: { [weak self] countries in
            if !countries.isEmpty {
                self?.tableView.reloadData()
            }
        })
        
        viewModel?.error.observe(on: self, observerBlock: { [weak self] errorMessage in
            if !errorMessage.isEmpty {
                self?.displayError(message: errorMessage)
            }
        })
    }
    
    private func configureUI() {
        navigationItem.searchController = self.searchController
        searchController.isActive = true
        title = "World countries 🇧🇬🇩🇪🇺🇸🇦🇩"
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withClass: CountryTableViewCell.self) else {
            assertionFailure("Failed to dequeue \(CountryTableViewCell.self)!")
            return UITableViewCell()
        }
        
        let model = viewModel.countries.value[indexPath.row]
        cell.update(with: model.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.value.count
    }
    
}

extension CountriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.countries.value[indexPath.row]
        viewModel.didSelectCountry(country: model)
        searchController.searchBar.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
}

// MARK: - ErrorDisplayable
extension CountriesViewController: ErrorDisplayable {
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Ops we have a problem!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension CountriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didSearch(country: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearching()
    }
    
}

