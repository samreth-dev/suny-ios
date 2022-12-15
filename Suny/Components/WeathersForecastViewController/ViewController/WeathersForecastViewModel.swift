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
    case minute = "Minutely Forecast"
}

protocol WeathersForecastViewModelProtocol {
    var sections: [Section] { get set }
    var cityString: String? { get set }
    var tempString: String? { get set }
    var iconString: String? { get set }
    var attribution: WeatherAttribution? { get set }
    
    func getWeathers(index: Int) -> [AnyWeather]
}

class WeathersForecastViewModel {
    var sections: [Section]
    var cityString: String?
    var tempString: String?
    var iconString: String?
    var attribution: WeatherAttribution?
    private var weather: Weather?
    
    init(sections: [Section], cityString: String?, tempString: String?, iconString: String?, weather: Weather?, attribution: WeatherAttribution?) {
        self.sections = sections
        self.cityString = cityString
        self.tempString = tempString
        self.iconString = iconString
        self.weather = weather
        self.attribution = attribution
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

extension WeathersForecastViewModel: WeathersForecastViewModelProtocol {
    func getWeathers(index: Int) -> [AnyWeather] {
        switch index {
        case 0:
            return getDayWeathers()
        case 1:
            return getHourWeathers()
        case 2:
            return getMinuteWeathers()
        default:
            return []
        }
    }
}
