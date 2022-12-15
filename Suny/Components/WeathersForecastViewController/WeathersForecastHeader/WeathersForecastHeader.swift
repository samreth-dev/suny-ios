//
//  WeathersForecastHeader.swift
//  Suny
//
//  Created by Samreth Kem on 12/11/22.
//

import UIKit

class WeathersForecastHeader: UIView {
    private var cityLabel: UILabel!
    private var imageView: UIImageView!
    private var temperLabel: UILabel!
    private var stackView: UIStackView!
    private var leftSpacer: UILayoutGuide!
    private var viewModel: WeathersForecastHeaderViewModelProtocol!
    
    init(viewModel: WeathersForecastHeaderViewModelProtocol) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        initViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: bounds.midY/2),
            
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 35),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -35),
            
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//MARK: private views configurations
private extension WeathersForecastHeader {
    func initViews() {
        stackView = UIStackView()
        cityLabel = UILabel()
        imageView = UIImageView()
        temperLabel = UILabel()
        addSubview(stackView)
        addSubview(cityLabel)
        addSubview(imageView)
        addSubview(temperLabel)
    }
    
    func setupViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.addArrangedSubview(temperLabel)
        stackView.addArrangedSubview(imageView)
        stackView.distribution = .fillEqually
        
        cityLabel.text = viewModel.cityString ?? "N/A"
        cityLabel.font = .systemFont(ofSize: 45, weight: .bold)
        cityLabel.textColor = .white
        cityLabel.textAlignment = .center
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        temperLabel.text = viewModel.tempString ?? "N/A"
        temperLabel.font = .systemFont(ofSize: 35, weight: .bold)
        temperLabel.textColor = .systemMint
        temperLabel.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: viewModel.iconString ?? "cloud.fill")
        imageView.tintColor = .systemYellow
    }
}
