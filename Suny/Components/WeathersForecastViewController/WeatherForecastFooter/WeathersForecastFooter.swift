//
//  WeathersForecastFooter.swift
//  Suny
//
//  Created by Samreth Kem on 12/12/22.
//

import UIKit

class WeathersForecastFooter: UIView {
    private var tradeMarkImage: UIImageView!
    private var tradeMarkLabel: UILabel!
    private var viewModel: WeathersForecastFooterViewModelProtocol
    
    init(viewModel: WeathersForecastFooterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: CGRect())
        initViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            tradeMarkImage.widthAnchor.constraint(equalToConstant: 100),
            tradeMarkImage.heightAnchor.constraint(equalToConstant: 40),
            tradeMarkImage.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            tradeMarkImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tradeMarkLabel.topAnchor.constraint(equalTo: tradeMarkImage.bottomAnchor, constant: -3),
            tradeMarkLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

//MARK: private functions
private extension WeathersForecastFooter {
    func initViews() {
        tradeMarkImage = UIImageView()
        tradeMarkLabel = UILabel()
        addSubview(tradeMarkImage)
        addSubview(tradeMarkLabel)
    }
    
    func setupViews() {
        tradeMarkImage.translatesAutoresizingMaskIntoConstraints = false
        tradeMarkImage.image = UIImage(systemName: "person")
        tradeMarkImage.contentMode = .scaleAspectFit
        tradeMarkImage.sd_setImage(with: viewModel.imageUrl, placeholderImage: UIImage(systemName: "cloud.fill"))
        
        tradeMarkLabel.translatesAutoresizingMaskIntoConstraints = false
        tradeMarkLabel.text = "Other Data Sources"
        tradeMarkLabel.font = .systemFont(ofSize: 13, weight: .bold)
        tradeMarkLabel.isUserInteractionEnabled = true
        tradeMarkLabel.textColor = .systemBlue
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewSource))
        gesture.numberOfTapsRequired = 1
        tradeMarkLabel.addGestureRecognizer(gesture)
    }
    
    @objc func viewSource() {
        viewModel.sourceCallBack()
    }
}
