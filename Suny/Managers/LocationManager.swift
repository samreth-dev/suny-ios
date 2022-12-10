//
//  LocationManager.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: NSObject {
    func didFetch(location: CLLocation)
}

protocol LocationManagerProtocol {
    var delegate: LocationManagerDelegate? { get set }
    func requestLocationAuth()
}

class LocationManager: NSObject, LocationManagerProtocol {
    weak var delegate: LocationManagerDelegate?
    private var clmanager = CLLocationManager()
    
    init(delegate: LocationManagerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func requestLocationAuth() {
        clmanager.delegate = self
        clmanager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.didFetch(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            clmanager.startUpdatingLocation()
        case .authorizedWhenInUse:
            clmanager.startUpdatingLocation()
        case .denied:
            debugPrint("denied")
        case .notDetermined:
            debugPrint("notDetermined")
        case .restricted:
            debugPrint("restricted")
        default:
            debugPrint("unknown")
        }
    }
}
