//
//  WeatherManager.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import WeatherKit
import CoreLocation

protocol WeatherManagerProtocol {
    var weather: Weather? { get set }
    func fetchWeather(location: CLLocation)
}

class WeatherManager: WeatherManagerProtocol {
    private let service = WeatherService.shared
    var weather: Weather?
    
    init(weather: Weather?) {
        self.weather = weather
    }
    
    func fetchWeather(location: CLLocation) {
        Task {
            try? await service.weather(for: location)
        }
    }
}
