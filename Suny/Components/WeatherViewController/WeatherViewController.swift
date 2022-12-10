//
//  ViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocationUI
import Combine

class WeatherViewController: UIViewController {
    private var temperLabel: UILabel!
    private var locationButton: CLLocationButton!
    private var viewModel: WeatherViewModelProtocol
    private var cancellable: Set<AnyCancellable>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupViews()
        binding()
    }
    
    init(viewModel: WeatherViewModelProtocol, cancellable: Set<AnyCancellable>) {
        self.viewModel = viewModel
        self.cancellable = cancellable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            temperLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            temperLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            temperLabel.topAnchor.constraint(equalTo: locationButton.bottomAnchor)
        ])
    }
    
    private func initViews() {
        locationButton = CLLocationButton()
        temperLabel = UILabel()
        temperLabel.textColor = .black
        view.addSubview(locationButton)
        view.addSubview(temperLabel)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        locationButton.icon = .arrowFilled
        locationButton.label = .shareCurrentLocation
        locationButton.addTarget(self, action: #selector(requestLocation), for: .touchUpInside)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        temperLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func binding() {
        viewModel.publisher.receive(on: DispatchQueue.main).sink { weather in
            self.temperLabel.text = weather?.currentWeather.temperature.description
        }.store(in: &cancellable)
    }
    
    @objc func requestLocation () {
        viewModel.fetchWeather()
    }
}

