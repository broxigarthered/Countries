//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 23.03.23.
//

import UIKit
import SVGKit
import MapKit

class CountryDetailsViewController: UIViewController, SkeletonLoadable {
    
    private let viewModel: CountryDetailsViewModel
    private let cache: ImageCacheType
    
    @IBOutlet weak var flagImageView: UIImageView! {
        didSet {
            
            flagImageView.contentMode = .scaleAspectFill
            
            // This adds loading animation of the image with transition between two gray colors as it's cooler than standard loading indicator
            let gradient = CAGradientLayer()
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            flagImageView.layer.addSublayer(gradient)
            let animationGroup = makeAnimationGroup()
            gradient.add(animationGroup, forKey: "backgroundColor")
            gradient.frame = flagImageView.bounds
        }
    }
    
    @IBOutlet weak var countryNameLabel: UILabel! {
        didSet {
            countryNameLabel.numberOfLines = 0
            countryNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            countryNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            countryNameLabel.text = viewModel.country.name
        }
    }
    
    @IBOutlet weak var regionNameLabel: UILabel! {
        didSet {
            regionNameLabel.numberOfLines = 0
            regionNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            regionNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            regionNameLabel.text = viewModel.country.region
        }
    }
    
    @IBOutlet weak var populationLabel: UILabel! {
        didSet {
            populationLabel.numberOfLines = 0
            populationLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            populationLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            populationLabel.text = String(viewModel.country.population)
        }
    }
    
    @IBOutlet weak var capitalNameLabel: UILabel! {
        didSet {
            capitalNameLabel.numberOfLines = 0
            capitalNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            capitalNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            capitalNameLabel.text = viewModel.country.capitalName
        }
    }
    
    @IBOutlet weak var mapKitView: MKMapView! {
        didSet {
            let latitude: CLLocationDegrees = viewModel.country.latLng[0]
            let longitude: CLLocationDegrees = viewModel.country.latLng[1]
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
            let region = MKCoordinateRegion(center: location, span: span)
            mapKitView.setRegion(region, animated: true)
        }
    }
    
    init(viewModel: CountryDetailsViewModel, imageCache: ImageCacheType) {
        self.viewModel = viewModel
        self.cache = imageCache
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.country.name
        
        guard let url = URL(string: viewModel.country.flag) else { return }
        loadImage(from: url)
    }
    
    private func imageDidLoad(with image: UIImage) {
        self.flagImageView.layer.sublayers?.removeAll()
        self.flagImageView.image = image
        self.flagImageView.layer.borderWidth = 1
        self.flagImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    public func loadImage(from url: URL) {
        if let image = cache[url] {
            self.imageDidLoad(with: image)
            return
        }
        
        DispatchQueue.global().async {
            let svgImage = SVGKImage(contentsOf: url)
            DispatchQueue.main.async {
                if let svgImage = svgImage {
                    if let uiImage = svgImage.uiImage.resized(withPercentage: 0.1) {
                        self.cache[url] = uiImage
                        self.imageDidLoad(with: uiImage)
                    }
                }
            }
        }
    }
    
}
