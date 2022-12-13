//
//  LocationManager.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    var delegate: LocationManagerDelegate? { get set }
    func requestLocationAuth()
}

protocol LocationManagerDelegate: NSObject {
    func didFetch(location: CLLocation)
}

class LocationManager: NSObject{
    weak var delegate: LocationManagerDelegate?
    private var clmanager = CLLocationManager()
    
    init(delegate: LocationManagerDelegate? = nil) {
        self.delegate = delegate
    }
}

extension LocationManager: LocationManagerProtocol {
    func requestLocationAuth() {
        clmanager.delegate = self
        clmanager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        if let delegate {
            delegate.didFetch(location: location)
            clmanager.stopUpdatingLocation()
        }
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
