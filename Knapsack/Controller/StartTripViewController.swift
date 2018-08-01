//
//  StartTripViewController.swift
//  Knapsack
//
//  Created by Noah Woodward on 7/31/18.
//  Copyright © 2018 Noah Woodward. All rights reserved.
//

import UIKit
import LocationPicker
class StartTripViewController: UIViewController {
    var longitude: Double?
    var latitude: Double?
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func locationButtonPressed(_ sender: Any) {
      locationButton.backgroundColor = UIColor.green
    let locationPicker = LocationPickerViewController()
    
        locationPicker.completion = { location in
            self.latitude = location?.coordinate.latitude
            self.longitude = location?.coordinate.longitude
 
        }
        
        navigationController?.pushViewController(locationPicker, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let homeVC = segue.destination as? HomeViewController else{return}
        guard let latitude = latitude else {return}
        guard let longitude = longitude else {return}
        homeVC.latitude = latitude
        homeVC.longitude = longitude
        
        
    }
    
    
    
    @IBAction func startTripButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    



}




    
    
 


