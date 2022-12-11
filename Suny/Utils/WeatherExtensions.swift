//
//  WeatherExtensions.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import WeatherKit
import Foundation

protocol CustomWeather {
    associatedtype T
    var weather: T { get set }
    func getIcon() -> String
    func getTime() -> String
    func getTemp() -> String
}

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

extension CurrentWeather {
    func getIcon() -> String {
        self.symbolName
    }
    
    func getTemp() -> String {
        self.temperature.description
    }
    
    func getDew() -> String {
        "Dew\n" + self.dewPoint.description
    }
    
    func getWind() -> String {
        "Wind\n" + self.wind.speed.description
    }
    
    func getHumidity() -> String {
        "Humidity\n" + (Int(self.humidity*100)).description + "%"
    }
    
    func getCloud() -> String {
        "Cloud\n" + (Int(self.cloudCover*100)).description + "%"
    }
    
    func getCondition() -> String {
        self.condition.description
    }
}

extension DayWeather: CustomWeather {
    var weather: DayWeather {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    func getIcon() -> String {
        self.symbolName
    }
    
    func getTime() -> String {
        String(self.date.formatted(date: .abbreviated, time: .omitted).dropLast(6))
    }
    
    func getTemp() -> String {
        self.highTemperature.description
    }
}

extension HourWeather: CustomWeather {
    var weather: HourWeather {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    func getIcon() -> String {
        self.symbolName
    }
    
    func getTime() -> String {
        self.date.formatted(date: .omitted, time: .shortened).replacing(":00", with: "")
    }
    
    func getTemp() -> String {
        self.temperature.description
    }
}
extension MinuteWeather: CustomWeather {
    var weather: MinuteWeather {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    func getIcon() -> String {
        "sun.min"
    }
    
    func getTime() -> String {
        self.date.formatted(date: .omitted, time: .shortened).replacing(":00", with: "")
    }
    
    func getTemp() -> String {
        self.precipitation.description
    }
}
