//
//  WeathersForecastViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import Foundation
import WeatherKit

enum Section: String, CaseIterable {
    case day = "Daily Forecast"
    case hour = "Hourly Forecast"
    case minute = "Minutely Weathers"
}

protocol WeathersForecastViewModelProtocol {
    func getWeathers(index: Int) -> [any CustomWeather]
    var sections: [Section] { get set }
    var cityString: String? { get set }
    var tempString: String? { get set }
    var iconString: String? { get set }
}

class WeathersForecastViewModel: WeathersForecastViewModelProtocol {
    var sections: [Section]
    var cityString: String?
    var tempString: String?
    var iconString: String?
    private var weather: Weather?
    
    init(sections: [Section], cityString: String?, tempString: String?, iconString: String?, weather: Weather?) {
        self.sections = sections
        self.cityString = cityString
        self.tempString = tempString
        self.iconString = iconString
        self.weather = weather
    }
    
    func getWeathers(index: Int) -> [any CustomWeather] {
        switch index {
        case 0:
            print("this1")
            return getDayWeathers()
        case 1:
            print("this2")
            return getHourWeathers()
        case 2:
            print("this3")
            return getMinuteWeathers()
        default:
            return []
        }
    }
    
    private func getDayWeathers() -> [DayWeather] {
        weather?.dailyForecast.forecast ?? []
    }
    
    private func getHourWeathers() -> [HourWeather] {
        weather?.hourlyForecast.forecast ?? []
    }
    
    private func getMinuteWeathers() -> [MinuteWeather] {
        weather?.minuteForecast?.forecast ?? []
    }
}
