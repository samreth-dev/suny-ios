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
    var publisher: Published<CurrentWeather?>.Publisher { get }
    var publishers: Published<[HourWeather]>.Publisher { get }
    var bottomImages: [String] { get set }
    var weathers: [HourWeather] { get set }
    func fetchWeather(location: CLLocation)
    func fetchCity(location: CLLocation) -> String
}

class WeatherViewModel: WeatherViewModelProtocol {
    var publishers: Published<[HourWeather]>.Publisher { $weathers}
    var publisher: Published<CurrentWeather?>.Publisher { $weather }
    @Published var weathers: [HourWeather]
    @Published var weather: CurrentWeather?
    var bottomImages: [String]
    private var weatherManager: WeatherManagerProtocol
    
    init(weathers: [HourWeather], bottomImages: [String], weather: CurrentWeather?, weatherManager: WeatherManagerProtocol) {
        self.weathers = weathers
        self.bottomImages = bottomImages
        self.weather = weather
        self.weatherManager = weatherManager
    }
    
    func fetchWeather(location: CLLocation) {
        Task { [weak self] in
            guard let self else { return }
            if let result = await weatherManager.fetchWeather(location: location) {
                self.weather = result.currentWeather
                self.weathers = result.todayHourWeathers.nextHourWeathers
            }
        }
    }
    
    func fetchCity(location: CLLocation) -> String {
        var cityResult = ""
        location.fetchCityAndCountry { city, country, error in
            cityResult = city ?? "N/A"
        }
        return cityResult
    }
}

