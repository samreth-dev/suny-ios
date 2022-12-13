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
    var publisher: Published<CurrentWeather?>.Publisher { get }
    var publishers: Published<[HourWeather]>.Publisher { get }
    var bottomImages: [String] { get set }
    var mainWeather: Weather? { get set }
    var weathers: [HourWeather] { get set }
    var attribution: WeatherAttribution? { get set }
    var cancellable: Set<AnyCancellable> { get set }
    
    func fetchWeather(location: CLLocation)
    func fetchCity(location: CLLocation, callback: @escaping (String) -> ())
}

class WeatherViewModel {
    @Published var weathers: [HourWeather]
    @Published var weather: CurrentWeather?
    var publishers: Published<[HourWeather]>.Publisher { $weathers}
    var publisher: Published<CurrentWeather?>.Publisher { $weather }
    var mainWeather: Weather?
    var attribution: WeatherAttribution?
    var bottomImages: [String]
    var cancellable: Set<AnyCancellable>
    private var weatherManager: WeatherManagerProtocol
    
    init(weathers: [HourWeather], weather: CurrentWeather?, mainWeather: Weather?, attribution: WeatherAttribution?, bottomImages: [String], weatherManager: WeatherManagerProtocol, cancellable: Set<AnyCancellable>) {
        self.weathers = weathers
        self.weather = weather
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
                self.weather = result.0.currentWeather
                self.mainWeather = result.0
                self.attribution = result.1
                self.weathers = result.0.todayHourWeathers.nextHourWeathers
            }
        }
    }
    
    func fetchCity(location: CLLocation, callback: @escaping (String) -> ()) {
        location.fetchCityAndCountry { city, country, error in
            callback(city ?? "N/A")
        }
    }
}