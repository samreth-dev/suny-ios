//
//  WeathersForecastCellViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import Foundation
import WeatherKit

protocol WeathersForecastCellViewModelProtocol {
    var weathers: [AnyWeather] { get set }
}

class WeathersForecastCellViewModel: WeathersForecastCellViewModelProtocol {
    var weathers: [AnyWeather]
    init(weathers: [AnyWeather]) {
        self.weathers = weathers
    }
}
