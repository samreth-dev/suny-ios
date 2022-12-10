//
//  WeatherViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import WeatherKit

protocol WeatherViewModelProtocol {
    var publisher: Published<Weather?>.Publisher { get }
    func fetchWeather()
}

class WeatherViewModel: WeatherViewModelProtocol {
    var publisher: Published<Weather?>.Publisher { $weather }
    @Published private var weather: Weather?
    private var weatherManager: WeatherManagerProtocol
    private var locationManager: LocationManagerProtocol
    
    init(weather: Weather?, weatherManager: WeatherManagerProtocol, locationManager: LocationManagerProtocol) {
        self.weather = weather
        self.weatherManager = weatherManager
        self.locationManager = locationManager
    }
    
    func fetchWeather() {
        locationManager.requestLocationAuth()
        locationManager.requestCurrentLocation()
        guard let location = locationManager.location else { return }
        weatherManager.fetchWeather(location: location)
    }
}
