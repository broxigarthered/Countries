//
//  Country.swift
//  Countries
//
//  Created by Nikolay N. Dutskinov on 20.03.23.
//

import Foundation

struct Country: Decodable {
    let capitalName: String
    let code: String
    let flag: String
    let latLng: [Double]
    let name: String
    let population: Int
    let region: String
    let subregion: String
}
