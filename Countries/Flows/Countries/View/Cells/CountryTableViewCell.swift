//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 21.03.23.
//

import UIKit
import SVGKit

class CountryTableViewCell: UITableViewCell, NibProvidable, ReusableView, SkeletonLoadable {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func update(with title: String) {
        titleLabel.text = title
    }
    
}
