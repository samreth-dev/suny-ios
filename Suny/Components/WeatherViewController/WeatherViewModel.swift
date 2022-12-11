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
    var mainWeather: Weather? { get set }
    var weathers: [HourWeather] { get set }
    func fetchWeather(location: CLLocation)
    func fetchCity(location: CLLocation, callback: @escaping (String) -> ())
}

class WeatherViewModel: WeatherViewModelProtocol {
    var publishers: Published<[HourWeather]>.Publisher { $weathers}
    var publisher: Published<CurrentWeather?>.Publisher { $weather }
    @Published var weathers: [HourWeather]
    @Published var weather: CurrentWeather?
    var mainWeather: Weather?
    var bottomImages: [String]
    private var weatherManager: WeatherManagerProtocol
    
    init(weathers: [HourWeather], weather: CurrentWeather?, mainWeather: Weather?, bottomImages: [String], weatherManager: WeatherManagerProtocol) {
        self.weathers = weathers
        self.weather = weather
        self.mainWeather = mainWeather
        self.bottomImages = bottomImages
        self.weatherManager = weatherManager
    }
    
    func fetchWeather(location: CLLocation) {
        Task { [weak self] in
            guard let self else { return }
            if let result = await weatherManager.fetchWeather(location: location) {
                self.weather = result.currentWeather
                self.weathers = result.todayHourWeathers.nextHourWeathers
                self.mainWeather = result
            }
        }
    }
    
    func fetchCity(location: CLLocation, callback: @escaping (String) -> ()) {
        location.fetchCityAndCountry { city, country, error in
            callback(city ?? "N/A")
        }
    }
}

