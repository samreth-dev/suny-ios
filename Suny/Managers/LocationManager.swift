//
//  LocationManager.swift
//  Suny
//
//  Created by Samreth Kem on 12/9/22.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    var location: CLLocation? { get set }
    func requestLocationAuth()
    func requestCurrentLocation()
}

class LocationManager: NSObject, LocationManagerProtocol {
    var location: CLLocation?
    private var clmanager = CLLocationManager()
    
    override init() {
        super.init()
        self.clmanager.delegate = self
    }
    
    init(location: CLLocation?) {
        self.location = location
    }
    
    func requestLocationAuth() {
        clmanager.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        if clmanager.authorizationStatus == .authorizedWhenInUse || clmanager.authorizationStatus == .authorizedAlways {
            clmanager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    debugPrint("hi")
                }
            }
        }
    }
}
