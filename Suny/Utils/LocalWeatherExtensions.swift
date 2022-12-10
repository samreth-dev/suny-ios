//
//  LocalWeatherExtensions.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import Foundation
import WeatherKit

extension LocalWeather {
    mutating func mapWeather(weather: CurrentWeather) {
        self.temperature = weather.temperature.description
        self.condition = weather.condition.description
        self.wind = "Wind\n" + weather.wind.speed.description
        self.uv = "UV\n" + weather.uvIndex.value.description
        self.humidity = "Humidity\n" + (Int(weather.humidity*100)).description + "%"
        self.cloud = "Cloud\n" + (Int(weather.cloudCover*100)).description + "%"
    }
}

extension Array<LocalWeather> {
    mutating func mapWeather(weathers: [HourWeather]) {
        weathers.forEach {
            var localWeather = LocalWeather()
            localWeather.icon = $0.condition.presentableImageString
            localWeather.time = $0.date.formatted(date: .omitted, time: .shortened).replacing(":00", with: "")
            localWeather.temperature = $0.temperature.description
            self.append(localWeather)
        }
    }
}
