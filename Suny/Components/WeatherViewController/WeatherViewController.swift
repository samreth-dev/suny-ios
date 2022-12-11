//
//  ViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocationUI
import Combine
import MapKit

class WeatherViewController: UIViewController {
    private var viewModel: WeatherViewModelProtocol
    private var cancellable: Set<AnyCancellable>
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dewLabel: UILabel!
    @IBOutlet weak var mainTemperLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    
    init(viewModel: WeatherViewModelProtocol, cancellable: Set<AnyCancellable>) {
        self.viewModel = viewModel
        self.cancellable = cancellable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        binding()
        locationConfiguration()
    }
}

//MARK: private views configurations
private extension WeatherViewController {
    func setupViews() {
        let nib = UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(nib, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        collectionViewFlowLayout.itemSize = CGSize(width: 110, height: 50)

        bottomImageView.image = UIImage(named: viewModel.bottomImages.randomElement() ?? "")
        bottomImageView.layer.backgroundColor = UIColor.black.cgColor
        
        locationButton.addTarget(self, action: #selector(locationConfiguration), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    func binding() {
        viewModel.publisher.receive(on: DispatchQueue.main).sink { [weak self] weather in
            guard let weather else { return }
            guard let self else { return }
            
            self.mainTemperLabel.text = weather.getTemp()
            self.conditionLabel.text = weather.getCondition()
            self.windLabel.text = weather.getWind()
            self.dewLabel.text = weather.getDew()
            self.humidityLabel.text = weather.getHumidity()
            self.cloudLabel.text = weather.getCloud()
            self.bottomImageView.image = UIImage(named: self.viewModel.bottomImages.randomElement() ?? "")
        }.store(in: &cancellable)
        
        viewModel.publishers.receive(on: DispatchQueue.main).sink { [weak self] weathers in
            if let self { self.collectionView.reloadData() }
        }.store(in: &cancellable)
    }
    
    @objc func locationConfiguration() {
        let locationManager = LocationManager()
        let viewModel = LocationViewModel(locationManager: locationManager) { [weak self] location ,city  in
            guard let self else { return }
            self.viewModel.fetchWeather(location: location)
            self.cityLabel.text = city
        }
        let destination = LocationViewController(viewModel: viewModel, cancellable: [])
        
        present(destination, animated: true)
    }
    
    @objc func search() {
        let viewModel = SearchViewModel(completer: MKLocalSearchCompleter(), results: []) { [weak self] location in
            guard let self else { return }
            self.viewModel.fetchWeather(location: location)
            self.viewModel.fetchCity(location: location) { city in
                self.cityLabel.text = city
            }
        }
        let destination = SearchViewController(viewModel: viewModel, cancellable: [])
        
        present(destination, animated: true)
    }
}

//MARK: datasource & delegate
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.weathers.count == 0 {
            collectionView.backgroundColor = .clear
            return 0
        } else {
            collectionView.backgroundColor = .black
            return viewModel.weathers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        let weather = viewModel.weathers[indexPath.row]
        let viewModel = WeatherCollectionViewCellViewModel(imageString: weather.getIcon(), temperString: weather.getTemp(), timeString: weather.getTime())

        cell.config(viewModel: viewModel)
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = Section.allCases
        let cityString = cityLabel.text
        let tempString = viewModel.mainWeather?.getTemp()
        let iconString = viewModel.mainWeather?.getIcon()
        let weather = viewModel.mainWeather
        let viewModel = WeathersForecastViewModel(sections: sections, cityString: cityString, tempString: tempString, iconString: iconString, weather: weather)
        
        present(WeathersForecastViewController(viewModel: viewModel), animated: true)
    }
}
