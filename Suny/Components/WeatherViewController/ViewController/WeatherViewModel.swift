//
//  WeatherViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import WeatherKit
import CoreLocation
import Combine

protocol WeatherViewModelProtocol {
    var currentWeatherPublisher: Published<CurrentWeather?>.Publisher { get }
    var hourWeathersPublisher: Published<[HourWeather]>.Publisher { get }
    var bottomImages: [String] { get set }
    var mainWeather: Weather? { get set }
    var hourWeathers: [HourWeather] { get set }
    var attribution: WeatherAttribution? { get set }
    var cancellable: Set<AnyCancellable> { get set }
    
    func fetchWeather(location: CLLocation)
    func fetchCity(location: CLLocation, callback: @escaping (String) -> ())
}

class WeatherViewModel {
    @Published var hourWeathers: [HourWeather]
    @Published var currentWeather: CurrentWeather?
    var hourWeathersPublisher: Published<[HourWeather]>.Publisher { $hourWeathers}
    var currentWeatherPublisher: Published<CurrentWeather?>.Publisher { $currentWeather }
    var mainWeather: Weather?
    var attribution: WeatherAttribution?
    var bottomImages: [String]
    var cancellable: Set<AnyCancellable>
    private var weatherManager: WeatherManagerProtocol
    
    init(hourWeathers: [HourWeather], currentWeather: CurrentWeather?, mainWeather: Weather?, attribution: WeatherAttribution?, bottomImages: [String], weatherManager: WeatherManagerProtocol, cancellable: Set<AnyCancellable>) {
        self.hourWeathers = hourWeathers
        self.currentWeather = currentWeather
        self.mainWeather = mainWeather
        self.attribution = attribution
        self.bottomImages = bottomImages
        self.weatherManager = weatherManager
        self.cancellable = cancellable
    }
}

extension WeatherViewModel: WeatherViewModelProtocol {
    func fetchWeather(location: CLLocation) {
        Task { [weak self] in
            guard let self else { return }
            if let result = await weatherManager.fetchWeather(location: location) {
                self.currentWeather = result.0.currentWeather
                self.mainWeather = result.0
                self.attribution = result.1
                self.hourWeathers = result.0.todayHourWeathers.nextHourWeathers
            }
        }
    }
    
    func fetchCity(location: CLLocation, callback: @escaping (String) -> ()) {
        location.fetchCityAndCountry { city, country, error in
            callback(city ?? "N/A")
        }
    }
}
