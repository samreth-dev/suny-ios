//
//  LocationViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import CoreLocation

protocol LocationViewModelProtocol {
    var publisher: Published<CLLocation?>.Publisher { get }
    var locationCallBack: (CLLocation, String) -> () { get set }
    func fetchLocation()
}

class LocationViewModel: NSObject, LocationViewModelProtocol {
    var publisher: Published<CLLocation?>.Publisher { $location }
    var locationCallBack: (CLLocation, String) -> ()
    private var locationManager: LocationManagerProtocol
    @Published private var location: CLLocation?
    
    init(location: CLLocation? = nil, locationManager: LocationManagerProtocol, locationCallBack: @escaping (CLLocation, String) -> Void) {
        self.location = location
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
            self?.location = location
        }
    }
}
