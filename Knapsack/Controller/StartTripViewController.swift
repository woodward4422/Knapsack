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
    var gender: Gender?
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    private var datePicker1 = UIDatePicker()
    private var datePicker2 = UIDatePicker()
    let dateFormatter1 = DateFormatter()
    let dateFormatter2 = DateFormatter()
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        datePicker1 = UIDatePicker()
        datePicker1.datePickerMode = .date
        datePicker1.addTarget(self, action: #selector(StartTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        datePicker2 = UIDatePicker()
        datePicker2.datePickerMode = .date
        datePicker2.addTarget(self, action: #selector(StartTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StartTripViewController.viewTapped(gestureRecognizer:)))
        
         view.addGestureRecognizer(tapGesture)
        
        inputTextField.inputView = datePicker1
        outputTextField.inputView = datePicker2
        
        
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
      
        if(inputTextField.text == "" || outputTextField.text == ""){
            let alert = UIAlertController(title: "No Date set", message: "Please set an arrival and departure date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        guard let homeVC = segue.destination as? HomeViewController else{return}
        guard let latitude = latitude else {return}
        guard let longitude = longitude else {return}
        
       
        homeVC.latitude = latitude
        homeVC.longitude = longitude
        homeVC.fromDate = inputTextField.text
        homeVC.toDate = outputTextField.text
        
        if(genderSegmented.selectedSegmentIndex == 0){
            homeVC.gender = .male
        }
        else{
            homeVC.gender = .female
        }
        
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        
        dateFormatter1.dateFormat = "yyyy-mm-dd"
        dateFormatter2.dateFormat = "yyyy-mm-dd"
        
        
        inputTextField.text = dateFormatter1.string(from: datePicker1.date)
        outputTextField.text = dateFormatter2.string(from: datePicker2.date)
        
        
    }
    
 
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        
    }
    
    
    func updateDateField(sender: UIDatePicker) {
        if sender == inputTextField
        {
            inputTextField.text = String(dateFormatter1.string(from: sender.date))
            
            
        }
        if sender == outputTextField
        {
            outputTextField.text = String(dateFormatter2.string(from: sender.date))
        }
        
    }
    
    
   @IBAction func unwindToStartTrip(segue:UIStoryboardSegue) {
    
    }
    
    
 
    
    
    
    
}









