//
//  WeatherExtensions.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import WeatherKit
import Foundation

extension Weather {
    var todayHourWeathers: [HourWeather] {
        get {
            return self.hourlyForecast.forecast.filter {
                Calendar.current.isDateInToday($0.date)
            }
        }
    }
}

extension Array<HourWeather> {
    var nextHourWeathers: [HourWeather] {
        return self.filter {
            $0.date.timeIntervalSince(Date()) > 0
        }
    }
}

extension WeatherCondition {
    var presentableImageString: String {
        get {
            switch self {
            case .blizzard:
                return "wind.snow"
            case .blowingDust:
                return "sun.dust.fill"
            case .blowingSnow:
                return "wind.snow"
            case .breezy:
                return "wind"
            case .clear:
                return "sun.max.fill"
            case .cloudy:
                return "cloud.fill"
            case .drizzle:
                return "cloud.drizzle.fill"
            case .flurries:
                return "cloud.snow.fill"
            case .foggy:
                return "cloud.fog.fill"
            case .freezingDrizzle:
                return "cloud.drizzle.fill"
            case .freezingRain:
                return "cloud.rain.fill"
            case .frigid:
                return "thermometer.snowflake"
            case .hail:
                return "cloud.hail.fill"
            case .haze:
                return "sun.haze.fill"
            case .heavyRain:
                return "cloud.heavyrain.fill"
            case .heavySnow:
                return "cloud.snow.fill"
            case .hot:
                return "thermometer.sun.fill"
            case .hurricane:
                return "hurricane"
            case .isolatedThunderstorms:
                return "cloud.bolt.fill"
            case .mostlyClear:
                return "sun.max.fill"
            case .mostlyCloudy:
                return "cloud.sun.fill"
            case .partlyCloudy:
                return "cloud.sun.fill"
            case .rain:
                return "cloud.rain.fill"
            case .scatteredThunderstorms:
                return "cloud.bolt.fill"
            case .sleet:
                return "cloud.sleet.fill"
            case .smoky:
                return "smoke.fill"
            case .snow:
                return "cloud.snow.fill"
            case .strongStorms:
                return "tropicalstorm"
            case .sunFlurries:
                return "cloud.snow.fill"
            case .sunShowers:
                return "cloud.sun.rain.fill"
            case .thunderstorms:
                return "cloud.bolt.fill"
            case .tropicalStorm:
                return "tropicalstorm"
            case .windy:
                return "wind"
            case .wintryMix:
                return "wind.snow"
            @unknown default:
                return "globe.americas.fill"
            }
        }
    }
}
