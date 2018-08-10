//
//  StartTripViewController.swift
//  Knapsack
//
//  Created by Noah Woodward on 7/31/18.
//  Copyright © 2018 Noah Woodward. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import AVFoundation
class StartTripViewController: UIViewController {
    var longitude: Double?
    var latitude: Double?
    var gender: Gender?
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    private var datePicker1 = UIDatePicker()
    private var datePicker2 = UIDatePicker()
    let dateFormatter1 = DateFormatter()
    let dateFormatter2 = DateFormatter()
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var packButton: UIButton!
    @IBOutlet weak var setLocationField: UITextField!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextField!
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    
    deinit {
        print("Start View Trip Deleted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Add video Login with loop so it doesnt crash
//        guard let theURL = Bundle.main.path(forResource: "sanfran", ofType: "mp4") else {
//            print("Nothing")
//            return}
//        let videoURL = URL(fileURLWithPath: theURL)
//        avPlayer = AVPlayer(url:videoURL)
//        avPlayerLayer = AVPlayerLayer(player: avPlayer)
//        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        avPlayer.volume = 0
//        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
//
//        avPlayerLayer.frame = view.layer.bounds
//        view.backgroundColor = UIColor.clear;
//        view.layer.insertSublayer(avPlayerLayer, at: 0)
//        avPlayer.play()
//
//        NotificationCenter.default.addObserver(self,
//                                                         selector: "playerItemDidReachEnd",
//                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                                                         object: avPlayer.currentItem)
//
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isFirstScreen")
        GMSPlacesClient.provideAPIKey(Constants.GPAPIKey)
        GMSServices.provideAPIKey(Constants.GPAPIKey)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        
        setLocationField.delegate = self
        datePicker1 = UIDatePicker()
        datePicker1.minimumDate = Date()
        datePicker1.datePickerMode = .date
        datePicker1.addTarget(self, action: #selector(StartTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        datePicker2 = UIDatePicker()
        datePicker2.minimumDate = Date()
        datePicker2.datePickerMode = .date
        datePicker2.addTarget(self, action: #selector(StartTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StartTripViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        
        inputTextField.inputView = datePicker1
        outputTextField.inputView = datePicker2
//        inputTextField.layer.cornerRadius = rounded ? inputTextField.size.height / 2 : 0
//        inputTextField.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
//    func playerItemDidReachEnd(notification: Notification){
//        avPlayer.seek(to: kCMTimeZero)
//        avPlayer.play()
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
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
        
        datePicker2.minimumDate = datePicker1.date
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        
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
    
    
    
    
    @IBAction func startTripButtonPressed(_ sender: Any) {
        if(inputTextField.text == "" || outputTextField.text == "" || setLocationField.text == ""){
            let alert = UIAlertController(title: "Information Missing", message: "Please make sure to fill out all the fields to begin packing", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let parentVc = self.presentingViewController {
                performSegue(withIdentifier:"unwindToHomeViewController" , sender: nil)
            } else {
                
                performSegue(withIdentifier:"showHomeViewController" , sender: nil)
            }
        }
    }
    
    
    
    
}

extension StartTripViewController:  CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        setLocationField.text = place.formattedAddress
        guard let formatedAdress = place.formattedAddress else {return}
        WeatherService.getGeoLocation(location:formatedAdress) { (lat, long) in
            print("Location: \(lat), \(long)")
            self.longitude = lat
            self.latitude = long
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    
}








