//
//  LocationsTableViewController.swift
//  My Places
//
//  Created by Jassem Al-Buloushi on 12/5/19.
//  Copyright © 2019 Jassem Al-Buloushi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class LocationsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //Variables
    
    var locationsSnapshots : [DataSnapshot] = []
    
    let locationManager = CLLocationManager()
    
    var userLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Manager setup
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        //Loading locations from Firebase
        
        Database.database().reference().child("Locations").observe(.childAdded) { (snapshot) in
            
            self.locationsSnapshots.append(snapshot)
            
            self.tableView.reloadData()
            
        }
        
        //Reload table view with Timer
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            
            self.tableView.reloadData()
            
        }
        
        
        
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationsSnapshots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        let snapshot = locationsSnapshots[indexPath.row]
        
        if let locationsDictionary = snapshot.value as? [String : Any] {
            
            if let name = locationsDictionary["Name"] as? String {
                
                if let lat = locationsDictionary["lat"] as? Double {
                    
                    if let lon = locationsDictionary["lon"] as? Double {
                        
                        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                        
                        let locationCLLocation = CLLocation(latitude: lat, longitude: lon)
                        
                        let distance = userCLLocation.distance(from: locationCLLocation) / 1000
                        
                        let roundedDistance = roundingDouble(num: distance)
                        
                        cell.textLabel?.text = "\(name) - \(roundedDistance)km away"
                        
                    }
                    
                }
                
                
            }
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Create Alert Controller with nav and share buttons
        
        let ac = UIAlertController(title: "Go to location or share it", message: nil, preferredStyle: .alert)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
            
            let snapshot = self.locationsSnapshots[indexPath.row]
            
            if let locationsDictionary = snapshot.value as? [String : Any] {
                
                if let name = locationsDictionary["Name"] as? String {
                    
                    if let lat = locationsDictionary["lat"] as? Double {
                        
                        if let lon = locationsDictionary["lon"] as? Double {
                            
                            let userCLLocation = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                            
                            let locationCLLocation = CLLocation(latitude: lat, longitude: lon)
                            
                            let distance = userCLLocation.distance(from: locationCLLocation) / 1000
                            
                            let roundedDistance = self.roundingDouble(num: distance)
                            
                            let textToShare = ["\(name) - \(roundedDistance)km away from your location"]
                            
                            //Set up Activity View Controller
                            
                            let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                            
                            self.present(activityVC, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        ac.addAction(shareAction)
        
        let navAction = UIAlertAction(title: "Navigate", style: .default) { (action) in
            
            let snapshot = self.locationsSnapshots[indexPath.row]
            
            if let locationsDictionary = snapshot.value as? [String : Any] {
                
                if let name = locationsDictionary["Name"] as? String {
                    
                    if let lat = locationsDictionary["lat"] as? Double {
                        
                        if let lon = locationsDictionary["lon"] as? Double {
                            
                            let locationCLLocation = CLLocation(latitude: lat, longitude: lon)
                            
                            CLGeocoder().reverseGeocodeLocation(locationCLLocation) { (placemarks, error) in
                                
                                if let placmarks = placemarks {
                                    
                                    if placmarks.count > 0 {
                                        
                                        let mkPlacemark = MKPlacemark(placemark: placmarks[0])
                                        
                                        let mapItem = MKMapItem(placemark: mkPlacemark)
                                        
                                        mapItem.name = name
                                        
                                        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                        
                                        mapItem.openInMaps(launchOptions: options)
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
            }
            
            
            
        }
        
        ac.addAction(navAction)
        
        present(ac, animated: true, completion: nil)
        
        
        
    }
    
    //MARK: - Location Manager Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            
            userLocation = coord
            
        }
        
    }
    
    //MARK: - My Methods
    
    
    func roundingDouble(num : Double) -> Double {
        
        let roundedNum = round(num * 100) / 100
        
        return roundedNum
    }
    
    
}
