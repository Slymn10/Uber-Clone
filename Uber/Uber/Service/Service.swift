//
//  Service.swift
//  Uber
//
//  Created by Süleyman Koçak on 12.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import CoreLocation
import Firebase
import GeoFire

let DB_REF = Database.database().reference()
let REF_USER = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")
let REF_TRIPS = DB_REF.child("trips")
class Service {
   static let shared = Service()

   func fetchUserData(uid: String, completion: @escaping (User) -> Void) {
      REF_USER.child(uid).observeSingleEvent(of: .value) { (snapshot) in
         guard let dictionary = snapshot.value as? [String: Any] else { return }
         let uid = snapshot.key
         let user = User(uid: uid, dict: dictionary)
         completion(user)
      }
   }

   func fetchDrivers(location: CLLocation, completion: @escaping (User) -> Void) {
      let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
      REF_DRIVER_LOCATIONS.observe(.value) { (snapshot) in
         geofire.query(at: location, withRadius: 50).observe(
            .keyEntered,
            with: { (uid, location) in
               self.fetchUserData(uid: uid) { user in
                  var driver = user
                  driver.location = location
                  completion(driver)
               }
            })
      }
   }

   func uploadTrip(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping (Error?, DatabaseReference) -> Void) {
      guard let uid = Auth.auth().currentUser?.uid else { return }
      let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
      let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
      let values =
         [
            "pickupCoordinates": pickupArray,
            "destinationCoordinates": destinationArray,
            "state": TripState.requested.rawValue,
         ] as [String: Any]
      REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)

   }

   func observeTrips(completion: @escaping (Trip) -> Void) {
      REF_TRIPS.observe(.childAdded) { (snapshot) in
         guard let dict = snapshot.value as? [String: Any] else { return }
         let uid = snapshot.key
         let trip = Trip(passengerUid: uid, dictionary: dict)
         completion(trip)
      }
   }

   func acceptTrip(trip: Trip, completion: @escaping (Error?, DatabaseReference) -> Void) {
      guard let uid = Auth.auth().currentUser?.uid else { return }
      let values = ["driverUid": uid, "state": TripState.accepted.rawValue] as [String: Any]
      REF_TRIPS.child(trip.passengerUid).updateChildValues(values, withCompletionBlock: completion)
   }

   func observeCurrentTrip(completion: @escaping (Trip) -> Void) {
      guard let uid = Auth.auth().currentUser?.uid else { return }
      REF_TRIPS.child(uid).observe(.value) { snapshot in
         guard let dict = snapshot.value as? [String: Any] else { return }
         let uid = snapshot.key
         let trip = Trip(passengerUid: uid, dictionary: dict)
         completion(trip)
      }
   }

   func cancelTrip(completion: @escaping (Error?, DatabaseReference) -> Void) {
      guard let uid = Auth.auth().currentUser?.uid else { return }
      REF_TRIPS.child(uid).removeValue(completionBlock: completion)
   }


}
