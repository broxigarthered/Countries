//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 23.03.23.
//

import UIKit
import SVGKit

class CountryDetailsViewController: UIViewController, SkeletonLoadable {
    
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
    
    private let viewModel: CountryDetailsViewModel
    private lazy var cache: ImageCacheType = ImageCache()
    
    init(viewModel: CountryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.country.name

        loadImage(from: URL(string: viewModel.country.flag)!)
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
