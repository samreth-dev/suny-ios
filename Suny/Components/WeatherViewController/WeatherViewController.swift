//
//  ViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocationUI

class WeatherViewController: UIViewController {
    private var temperLabel: UILabel!
    private var locationButton: CLLocationButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func initViews() {
        locationButton = CLLocationButton()
        temperLabel = UILabel()
        view.addSubview(locationButton)
        view.addSubview(temperLabel)
    }
    
    private func setupViews() {
        locationButton.icon = .arrowFilled
        locationButton.label = .shareCurrentLocation
        locationButton.addTarget(self, action: #selector(requestLocation), for: .touchUpInside)
    }
    
    @objc func requestLocation () {
        
    }
}

