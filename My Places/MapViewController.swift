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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    //Outlets
    @IBOutlet var map: MKMapView!
    
    //Variables
    var locationManager = CLLocationManager()
    
    var locationsDictionary = [String : Any]()

    
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
        
    }
    
    @IBAction func saveLocationPressed(_ sender: UIButton) {
        
        //Alert Controller
        
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add New Location", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let textFieldText = textField.text {
                
                let location = Location()
                
                location.name = textFieldText
                
                self.locationsDictionary = ["Name" : location.name, "lat" : 15, "lon" : 139.443, "City" : "Kuwait"]
                
                Database.database().reference().child("Locations").childByAutoId().setValue(self.locationsDictionary)
                
            }
            
        }
        
        ac.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Enter location name"
            
            textField = alertTextField
            
        }
        
        
        
        ac.addAction(action)
        
        present(ac, animated: true, completion: nil)
        
        
    }
    

}
