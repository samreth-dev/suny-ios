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
    var publisher: Published<LocalWeather?>.Publisher { get }
    var bottomImages: [String] { get set }
    var weathers: [LocalWeather] { get set }
    func fetchWeather(location: CLLocation)
}

class WeatherViewModel: WeatherViewModelProtocol {
    var weathers: [LocalWeather]
    var bottomImages: [String]
    var publisher: Published<LocalWeather?>.Publisher { $weather }
    @Published var weather: LocalWeather?
    private var weatherManager: WeatherManagerProtocol
    
    init(weathers: [LocalWeather], bottomImages: [String], weather: LocalWeather? = nil, weatherManager: WeatherManagerProtocol) {
        self.weathers = weathers
        self.bottomImages = bottomImages
        self.weather = weather
        self.weatherManager = weatherManager
    }
    
    func fetchWeather(location: CLLocation) {
        Task {
            if let result = await weatherManager.fetchWeather(location: location) {
                self.weather?.mapWeather(weather: result.currentWeather)
                self.weathers.mapWeather(weathers: result.hourlyForecast.forecast)
            }
        }
    }
}
