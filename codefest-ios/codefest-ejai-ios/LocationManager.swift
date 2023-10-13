//
//  LocationManager.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import SwiftUI
import MapKit
import Observation

@Observable final class LocationManager: NSObject  {
    
    private let systemManager = CLLocationManager()
    
    var userLocation: MapCameraPosition = .automatic
    var lastKnownLocation: CLLocationCoordinate2D?

        
        
    override init() {
        super.init()
        systemManager.delegate = self
        systemManager.desiredAccuracy = kCLLocationAccuracyBest
        systemManager.requestLocation()
        systemManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        print("Auth status = \(systemManager.authorizationStatus)")
        switch systemManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            systemManager.requestLocation()
        default:
            systemManager.requestAlwaysAuthorization()
            systemManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "My purpose") { error in
                if let e = error {
                    print("Temp Error: \(e.localizedDescription)")
                }
            }
        }
    }
    
    func startContantUpdates() {
        systemManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        systemManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager ERROR: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate

        locations.last.map {
            userLocation =  .camera(MapCamera(centerCoordinate: $0.coordinate, distance: 0.01, heading: $0.course, pitch: $0.altitude))
        }
    }
}
