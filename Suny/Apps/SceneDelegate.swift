//
//  SceneDelegate.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocation
import MapKit
import WeatherKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
  
        let weatherManager = WeatherManager()
        let weatherViewModel = WeatherViewModel(hourWeathers: [], currentWeather: nil, mainWeather: nil, attribution: nil, bottomImages: Constants.bottomImgStrings, weatherManager: weatherManager, cancellable: [])
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        let navigationController = UINavigationController(rootViewController: weatherViewController)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

