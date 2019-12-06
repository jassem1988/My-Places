//
//  MapViewController.swift
//  My Places
//
//  Created by Jassem Al-Buloushi on 12/2/19.
//  Copyright © 2019 Jassem Al-Buloushi. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    //Outlets
    @IBOutlet var map: MKMapView!
    
    //Variables
    var locationManager = CLLocationManager()
    
    var locationsDictionary = [String : Any]()
    
    var userLocation = CLLocationCoordinate2D()
    
    let location = Location()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Manager setup
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        
    }
    
    //MARK: - Location Manager Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Find user location
        
        if let coord = manager.location?.coordinate {
            
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            
            userLocation = center
            
            location.coord = "(\(userLocation.latitude), \(userLocation.longitude)" //save in location model
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            map.setRegion(region, animated: true)
            
            //Add annotation
            
            map.removeAnnotations(map.annotations) //Removes older annotations
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = center
            
            annotation.title = "Your Location"
            
            map.addAnnotation(annotation)
            
            
        }
        
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        try? Auth.auth().signOut()
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveLocationPressed(_ sender: UIButton) {
        
        //Alert Controller
        
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add New Location", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let textFieldText = textField.text {
                
                self.location.name = textFieldText //save in location model
                
                self.locationsDictionary = ["Name" : self.location.name, "lat" : self.userLocation.latitude, "lon" : self.userLocation.longitude, "City" : "Kuwait"]
                Database.database().reference().child("Locations").childByAutoId().setValue(self.locationsDictionary)
                
                self.performSegue(withIdentifier: "locationsSigue", sender: nil)
                
            }
            
        }
        
        ac.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Enter location name"
            
            textField = alertTextField
            
        }
        
        ac.addAction(action)
        
        present(ac, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func locationsButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "locationsSigue", sender: nil)
        
    }
    
    
    
}
