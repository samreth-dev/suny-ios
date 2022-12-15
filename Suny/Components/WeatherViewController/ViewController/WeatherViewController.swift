//
//  ViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocationUI
import MapKit
import SDWebImage
import SafariServices

class WeatherViewController: UIViewController {
    private var viewModel: WeatherViewModelProtocol!
    
    private var loadingBackground: UIView!
    private var loadingLabel: UILabel!
    @IBOutlet weak var sourceImage: UIImageView!
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
    @IBOutlet weak var sourceButton: UIButton!
    
    init(viewModel: WeatherViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        binding()
        locationConfiguration()
        loadingView(status: "Getting Current Location...", loadingTextColor: .white, loadingColor: .systemMint)
    }
}

//MARK: private views configurations
private extension WeatherViewController {
    func setupViews() {
        loadingLabel = UILabel()
        loadingLabel.frame = CGRect(x: 0, y: view.bounds.midY - 20, width: Constants.screenWidth, height: 40)
        loadingLabel.textAlignment = .center
        
        loadingBackground = UIView()
        loadingBackground.backgroundColor = .black
        loadingBackground.frame = Constants.screenFrame
        
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
        viewModel.currentWeatherPublisher.receive(on: DispatchQueue.main).sink { [weak self] weather in
            guard let weather else { return }
            guard let self else { return }
            
            self.mainTemperLabel.text = weather.getTemp()
            self.conditionLabel.text = weather.getCondition()
            self.windLabel.text = weather.getWind()
            self.dewLabel.text = weather.getDew()
            self.humidityLabel.text = weather.getHumidity()
            self.cloudLabel.text = weather.getCloud()
            self.bottomImageView.image = UIImage(named: self.viewModel.bottomImages.randomElement() ?? "")
        }.store(in: &viewModel.cancellable)
        
        viewModel.hourWeathersPublisher.receive(on: DispatchQueue.main).sink { [weak self] weathers in
            if let self {
                self.collectionView.reloadData()
                self.sourceImage.sd_setImage(with: self.viewModel.attribution?.combinedMarkDarkURL, placeholderImage: UIImage(systemName: "cloud.fill"))
                self.collectionView.reloadData()
            }
        }.store(in: &viewModel.cancellable)
    }
    
    func loadingView(status: String, loadingTextColor: UIColor, loadingColor: UIColor) {
        loadingBackground.alpha = 0.5
        
        loadingLabel.text = status
        loadingLabel.textColor = loadingTextColor
        loadingLabel.layer.backgroundColor = loadingColor.cgColor
        loadingLabel.alpha = 1
        
        view.addSubview(loadingBackground)
        view.addSubview(loadingLabel)
        view.addSubview(locationButton)
    }
}

//MARK: private actions
private extension WeatherViewController {
    @objc func locationConfiguration() {
        loadingView(status: "Getting Current Location...", loadingTextColor: .white, loadingColor: .systemMint)
        
        let locationManager = LocationManager(delegate: nil)
        let viewModel = LocationViewModel(locationManager: locationManager, cancellable: []) { [weak self] location ,city  in
            guard let self else { return }
            
            self.viewModel.fetchWeather(location: location)
            self.cityLabel.text = city
            self.searchButton.isUserInteractionEnabled = true
            self.searchButton.alpha = 1
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                UIView.animate(withDuration: 0.25) {
                    self.loadingLabel.alpha = 0
                    self.loadingBackground.alpha = 0
                }
            }
        }
        let destination = LocationViewController(viewModel: viewModel)
        
        present(destination, animated: true)
    }
    
    @objc func search() {
        let viewModel = SearchViewModel(completer: MKLocalSearchCompleter(), results: [], cancellable: []) { [weak self] location in
            guard let self else { return }
            
            self.loadingView(status: "Searching Location...", loadingTextColor: .black, loadingColor: .systemYellow)
            
            self.viewModel.fetchWeather(location: location)
            self.viewModel.fetchCity(location: location) { city in
                self.cityLabel.text = city
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                UIView.animate(withDuration: 0.25) {
                    self.loadingLabel.alpha = 0
                    self.loadingBackground.alpha = 0
                }
            }
        }
        let destination = SearchViewController(viewModel: viewModel)
        
        present(destination, animated: true)
    }
    
    @IBAction func viewSource(_ sender: Any) {
        guard let url = viewModel.attribution?.legalPageURL else { return }
        let sfViewController = SFSafariViewController(url: url)
        present(sfViewController, animated: true)
    }
}

//MARK: datasource & delegate
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.hourWeathers.count == 0 {
            collectionView.backgroundColor = .clear
            return 0
        } else {
            collectionView.backgroundColor = .black
            return viewModel.hourWeathers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell else { return UICollectionViewCell() }
        
        let weather = viewModel.hourWeathers[indexPath.row]
        let viewModel = WeatherCollectionViewCellViewModel(imageString: weather.getIcon(), temperString: weather.getTemp(), timeString: String(weather.getTime().dropLast(6)))

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
        let viewModel = WeathersForecastViewModel(sections: sections, cityString: cityString, tempString: tempString, iconString: iconString, weather: weather, attribution: viewModel.attribution)
        
        present(WeathersForecastViewController(viewModel: viewModel), animated: true)
    }
}
