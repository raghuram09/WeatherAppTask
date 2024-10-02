//
//  LocationManager.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    static let shared = LocationManager()
    let geocoder = CLGeocoder()
    private var locationFetchCompletion: ((String,String) -> Void)?
    private var location: (String,String)? {
        didSet {
            guard let location else {
                return
            }
            locationFetchCompletion?(location.0,location.1)
        }
    }
    public func getCurrentLocation(completion: @escaping (String,String) -> Void) {
        self.locationFetchCompletion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    // MARK: - Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                return
            }
            self.location = (placemark.locality ?? "", placemark.country ?? "")
        }
        manager.stopUpdatingLocation()
    }
}


