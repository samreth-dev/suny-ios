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
    private var viewModel: WeatherViewModelProtocol
    private var cancellable: Set<AnyCancellable>
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var mainTemperLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        binding()
        locationConfiguration()
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
    }
}

private extension WeatherViewController {
    func setupViews() {
        bottomImageView.contentMode = .scaleAspectFill
        bottomImageView.layer.cornerRadius = 30
        bottomImageView.image = UIImage(named: Constant.backgroundImages.randomElement() ?? "")
        
        locationButton.addTarget(self, action: #selector(locationConfiguration), for: .touchUpInside)
    }
    
    func binding() {
        viewModel.publisher.receive(on: DispatchQueue.main).sink { weather in
            guard let weather else { return }
            self.mainTemperLabel.text = weather.currentWeather.temperature.description
            self.conditionLabel.text = weather.currentWeather.condition.description
            self.windLabel.text = "Wind\n" + weather.currentWeather.wind.speed.description
            self.uvLabel.text = "UV\n" + weather.currentWeather.uvIndex.value.description
            self.humidityLabel.text = "Humidity\n" + (Int(weather.currentWeather.humidity*100)).description + "%"
            self.cloudLabel.text = "Cloud\n" + (Int(weather.currentWeather.cloudCover*100)).description + "%"
        }.store(in: &cancellable)
    }
    
    @objc func locationConfiguration() {
        let locationManager = LocationManager()
        let viewModel = LocationViewModel(locationManager: locationManager) { location ,city  in
            self.viewModel.fetchWeather(location: location)
            self.cityLabel.text = city
        }
        let destination = LocationViewController(viewModel: viewModel)
        
        present(destination, animated: true)
    }
}
