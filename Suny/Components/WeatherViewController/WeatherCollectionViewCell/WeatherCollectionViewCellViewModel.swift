//
//  WeatherCollectionViewCellViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import Foundation

protocol WeatherCollectionViewCellViewModelProtocol {
    var imageString: String { get set }
    var temperString: String { get set }
    var timeString: String { get set }
}

class WeatherCollectionViewCellViewModel: WeatherCollectionViewCellViewModelProtocol {
    var imageString: String
    var temperString: String
    var timeString: String
    
    init(imageString: String, temperString: String, timeString: String) {
        self.imageString = imageString
        self.temperString = temperString
        self.timeString = String(timeString.dropLast(6))
    }
}
