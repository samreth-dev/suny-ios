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
    func fetchWeather(location: CLLocation) async -> Weather?
}

class WeatherManager: WeatherManagerProtocol {
    private let service = WeatherService.shared
    
    func fetchWeather(location: CLLocation) async -> Weather? {
        try? await service.weather(for: location)
    }
}
