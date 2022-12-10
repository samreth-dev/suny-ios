//
//  WeatherViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import WeatherKit
import CoreLocation

protocol WeatherViewModelProtocol {
    var publisher: Published<Weather?>.Publisher { get }
    func fetchWeather(location: CLLocation)
}

class WeatherViewModel: WeatherViewModelProtocol {
    var publisher: Published<Weather?>.Publisher { $weather }
    @Published private var weather: Weather?
    private var weatherManager: WeatherManagerProtocol
    
    init(weather: Weather?, weatherManager: WeatherManagerProtocol) {
        self.weather = weather
        self.weatherManager = weatherManager
    }
    
    func fetchWeather(location: CLLocation) {
        Task {
            self.weather = await weatherManager.fetchWeather(location: location)
        }
    }
}
