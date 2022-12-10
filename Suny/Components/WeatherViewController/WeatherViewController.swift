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
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var mainTemperLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

private extension WeatherViewController {
    func setupViews() {
        let nib = UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
        collectionView.dataSource = self
        collectionView.register(nib
                                , forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        collectionViewFlowLayout.itemSize = CGSize(width: 120, height: 50)

        bottomImageView.image = UIImage(named: viewModel.bottomImages.randomElement() ?? "")
        bottomImageView.layer.backgroundColor = UIColor.black.cgColor
        
        locationButton.addTarget(self, action: #selector(locationConfiguration), for: .touchUpInside)
    }
    
    func binding() {
        viewModel.publisher.receive(on: DispatchQueue.main).sink { weather in
            guard let weather else { return }
            
            self.mainTemperLabel.text = weather.temperature
            self.conditionLabel.text = weather.condition
            self.windLabel.text = weather.wind
            self.uvLabel.text = weather.uv
            self.humidityLabel.text = weather.humidity
            self.cloudLabel.text = weather.cloud
            self.collectionView.reloadData()
        }.store(in: &cancellable)
    }
    
    @objc func locationConfiguration() {
        let locationManager = LocationManager()
        let viewModel = LocationViewModel(locationManager: locationManager) { location ,city  in
            self.viewModel.fetchWeather(location: location)
            self.cityLabel.text = city
        }
        let destination = LocationViewController(viewModel: viewModel, cancellable: [])
        present(destination, animated: true)
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        
        let weather = viewModel.weathers[indexPath.row]
        let viewModel = WeatherCollectionViewCellViewModel(imageString: weather.icon, temperString: weather.temperature, timeString: weather.time)
        
        cell.config(viewModel: viewModel)
        return cell
    }
    
}
