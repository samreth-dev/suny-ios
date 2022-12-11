//
//  WeathersForecastCellViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import Foundation
import WeatherKit

protocol WeathersForecastCellViewModelProtocol {
    var weathers: [any AnyWeather] { get set }
}

class WeathersForecastCellViewModel: WeathersForecastCellViewModelProtocol {
    var weathers: [any AnyWeather]
    init(weathers: [any AnyWeather]) {
        self.weathers = weathers
    }
}
