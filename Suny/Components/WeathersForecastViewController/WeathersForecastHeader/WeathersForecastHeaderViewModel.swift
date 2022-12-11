//
//  WeathersForecastHeaderViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/11/22.
//

import Foundation

protocol WeathersForecastHeaderViewModelProtocol {
    var cityString: String? { get set }
    var tempString: String? { get set }
    var iconString: String? { get set }
}

class WeathersForecastHeaderViewModel: WeathersForecastHeaderViewModelProtocol {
    var cityString: String?
    var tempString: String?
    var iconString: String?
    
    init(cityString: String?, tempString: String?, iconString: String?) {
        self.cityString = cityString
        self.tempString = tempString
        self.iconString = iconString
    }
}
