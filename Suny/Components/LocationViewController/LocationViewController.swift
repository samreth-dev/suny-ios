//
//  LocationViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocationUI
import Combine

class LocationViewController: UIViewController {
    @IBOutlet weak var requestLabel: UILabel!
    private var locationButton: CLLocationButton!
    private var viewModel: LocationViewModelProtocol
    private var cancellable: Set<AnyCancellable>
    
    init(viewModel: LocationViewModelProtocol, cancellable: Set<AnyCancellable>) {
        self.viewModel = viewModel
        self.cancellable = cancellable
        super.init(nibName: nil, bundle: nil)
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
            if location != nil, let self = self { self.dismiss(animated: true) }
        }.store(in: &cancellable)
    }
}
