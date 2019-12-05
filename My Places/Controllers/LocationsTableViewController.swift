//
//  LocationsTableViewController.swift
//  My Places
//
//  Created by Jassem Al-Buloushi on 12/5/19.
//  Copyright © 2019 Jassem Al-Buloushi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LocationsTableViewController: UITableViewController {
    
    //Variables
    
    var locationsSnapshots : [DataSnapshot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loading locations from Firebase
        
        Database.database().reference().child("Locations").observe(.childAdded) { (snapshot) in
            
            self.locationsSnapshots.append(snapshot)
            
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
                
                cell.textLabel?.text = name
                
            }
            
        }
        
        return cell
        
    }
    
    
}
