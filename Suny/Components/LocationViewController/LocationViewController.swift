//
//  LocationViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocationUI

class LocationViewController: UIViewController {
    @IBOutlet weak var requestLabel: UILabel!
    private var locationButton: CLLocationButton!
    private var viewModel: LocationViewModelProtocol!
    
    init(viewModel: LocationViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupViews()
        binding()
        viewModel.fetchLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            locationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            requestLabel.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -30),
            requestLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            requestLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
}

//MARK: private views configurations
private extension LocationViewController {
    func initViews() {
        locationButton = CLLocationButton()
        view.addSubview(locationButton)
    }
    
    func setupViews() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.label = .shareCurrentLocation
        locationButton.icon = .arrowFilled
        locationButton.backgroundColor = .systemMint
        locationButton.cornerRadius = 30
        
        requestLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func binding() {
        viewModel.publisher.receive(on: DispatchQueue.main).sink { [weak self] location in
            if let self { self.dismiss(animated: true) }
        }.store(in: &viewModel.cancellable)
    }
}
