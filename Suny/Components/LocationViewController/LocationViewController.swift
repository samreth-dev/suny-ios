//
//  LocationViewController.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import UIKit
import CoreLocationUI

class LocationViewController: UIViewController {
    private var locationButton: CLLocationButton!
    private var viewModel: LocationViewModelProtocol
    
    init(viewModel: LocationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupViews()
        viewModel.fetchLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            locationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    
    private func initViews() {
        locationButton = CLLocationButton()
        view.addSubview(locationButton)
    }
    
    private func setupViews() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.label = .shareCurrentLocation
        locationButton.icon = .arrowFilled
        locationButton.backgroundColor = .systemYellow
        locationButton.cornerRadius = 30
    }
}
