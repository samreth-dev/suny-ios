//
//  LocationViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import CoreLocation

protocol LocationViewModelProtocol {
    var locationCallBack: (CLLocation, String) -> () { get set }
    func fetchLocation()
}

class LocationViewModel: NSObject, LocationViewModelProtocol {
    var locationCallBack: (CLLocation, String) -> ()
    private var locationManager: LocationManagerProtocol
    
    init( locationManager: LocationManagerProtocol, locationCallBack: @escaping (CLLocation, String) -> Void) {
        self.locationCallBack = locationCallBack
        self.locationManager = locationManager
    }
    
    func fetchLocation() {
        locationManager.delegate = self
        locationManager.requestLocationAuth()
    }
}

extension LocationViewModel: LocationManagerDelegate {
    func didFetch(location: CLLocation) {
        location.fetchCityAndCountry { [weak self] city, country, error in
            self?.locationCallBack(location, city ?? "N/A")
        }
    }
}
