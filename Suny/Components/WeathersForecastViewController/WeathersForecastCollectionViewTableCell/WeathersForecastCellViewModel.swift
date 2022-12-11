//
//  WeathersForecastCellViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import Foundation
import WeatherKit

protocol WeathersForecastCellViewModelProtocol {
    var weathers: [any CustomWeather] { get set }
}

class WeathersForecastCellViewModel: WeathersForecastCellViewModelProtocol {
    var weathers: [any CustomWeather]
    init(weathers: [any CustomWeather]) {
        self.weathers = weathers
    }
}
