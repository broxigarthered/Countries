//
//  ViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import UIKit

class CountriesViewController: UIViewController {

    var viewModel: CountriesViewModel
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind(to viewModel: CountriesViewModel?) {
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
    }
    
}


