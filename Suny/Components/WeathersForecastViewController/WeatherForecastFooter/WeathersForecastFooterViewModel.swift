//
//  WeatherForecastFooterViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/12/22.
//

import Foundation

protocol WeathersForecastFooterViewModelProtocol {
    var imageUrl: URL { get set }
    var sourceCallBack: () -> () { get set }
}

class WeathersForecastFooterViewModel: WeathersForecastFooterViewModelProtocol {
    var imageUrl: URL
    var sourceCallBack: () -> ()
    init(imageUrl: URL, sourceCallBack: @escaping () -> Void) {
        self.sourceCallBack = sourceCallBack
        self.imageUrl = imageUrl
    }
}
