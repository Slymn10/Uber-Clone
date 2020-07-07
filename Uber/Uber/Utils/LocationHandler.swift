//
//  LocationHandler.swift
//  Uber
//
//  Created by Süleyman Koçak on 13.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import CoreLocation

class LocationHandler:NSObject,CLLocationManagerDelegate{
    static let shared = LocationHandler()
    var locationManager:CLLocationManager!
    var location : CLLocation?

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate=self
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       if status == .authorizedWhenInUse {
          locationManager.requestAlwaysAuthorization()
       }
    }

}
