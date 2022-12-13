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
    func fetchWeather(location: CLLocation) async -> (Weather, WeatherAttribution)?
}

class WeatherManager {
    private let service = WeatherService.shared
}

extension WeatherManager: WeatherManagerProtocol {
    func fetchWeather(location: CLLocation) async -> (Weather, WeatherAttribution)?  {
        let weather = try? await service.weather(for: location)
        let attribution = try? await service.attribution
        if let weather, let attribution {
            return (weather, attribution)
        } else {
            return nil
        }
    }
}
