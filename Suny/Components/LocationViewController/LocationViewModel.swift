//
//  LocationViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import CoreLocation
import Combine

protocol LocationViewModelProtocol {
    var publisher: Published<CLLocation?>.Publisher { get }
    var locationCallBack: (CLLocation, String) -> () { get set }
    var cancellable: Set<AnyCancellable> { get set }
    
    func fetchLocation()
}

class LocationViewModel: NSObject {
    var publisher: Published<CLLocation?>.Publisher { $location }
    var locationCallBack: (CLLocation, String) -> ()
    var cancellable: Set<AnyCancellable>
    private var locationManager: LocationManagerProtocol
    @Published private var location: CLLocation?
    
    init(location: CLLocation? = nil, locationManager: LocationManagerProtocol, cancellable: Set<AnyCancellable>, locationCallBack: @escaping (CLLocation, String) -> Void) {
        self.location = location
        self.locationCallBack = locationCallBack
        self.locationManager = locationManager
        self.cancellable = cancellable
    }
}

extension LocationViewModel: LocationViewModelProtocol {
    func fetchLocation() {
        locationManager.delegate = self
        locationManager.requestLocationAuth()
    }
}

extension LocationViewModel: LocationManagerDelegate {
    func didFetch(location: CLLocation) {
        location.fetchCityAndCountry { [weak self] city, country, error in
            guard let self else { return }
            self.locationCallBack(location, city ?? "N/A")
            self.location = location
        }
    }
}
