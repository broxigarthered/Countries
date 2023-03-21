//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import UIKit

class CountryTableViewCell: UITableViewCell, NibProvidable, ReusableView, SkeletonLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView! {
        didSet {
            let gradient = CAGradientLayer()
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            
            // Add the gradient to the label. Causes this sublayer to appear on top.
            flagImageView.layer.addSublayer(gradient)
            
            let animationGroup = makeAnimationGroup()
//            animationGroup.beginTime = 0.0
            gradient.add(animationGroup, forKey: "backgroundColor")
            
            // Set the gradients frame to the labels bounds
            gradient.frame = flagImageView.bounds
            
            // TODO: This removes the image
//            flagImageView.layer.sublayers?.removeAll()
        }
    }
    
//    private lazy var imageLoader = ImageLoader()
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func update(with title: String, imageURLString: String) {
        titleLabel.text = title
        
        guard let url = URL(string: imageURLString) else { return }
        downloadImage(from: url)
        
//        imageLoader.loadImage(from: url) { [weak self] result in
//            switch result {
//            case .success(let image):
//                self?.flagImageView.layer.sublayers?.removeAll()
//                self?.flagImageView.image = image
//            case .failure( _):
//                print("k")
//            }
//        }
    }
    
    
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to download image:", error)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to create image from data")
                return
            }
            
            DispatchQueue.main.async {
                self.flagImageView.image = image
            }
        }.resume()
    }
    
}


extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }
    
    static var gradientLightGrey: UIColor {
        return UIColor(red: 198 / 255.0, green: 198 / 255.0, blue: 198 / 255.0, alpha: 1)
    }
}






// TODO: Standard image download




// TODO: IMAGE CHACHE MOVE FROM HERE

// MARK: IMAGE LOAD
public protocol ImageLoadable {
    func loadImage(from url: URL, completion: @escaping (Result<UIImage,Error>) -> Void)
}

