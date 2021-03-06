//
//  ViewController.swift
//  Knapsack
//
//  Created by Noah Woodward on 7/30/18.
//  Copyright © 2018 Noah Woodward. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var longitude: Double?
    var latitude: Double?
//    var clothes = [String]()
    var clothingData = [Clothing]()
    var gender: Gender = .none
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var fromDate: String?
    var toDate: String?
    
    deinit {
        print("Home View Deleted")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clothingData = CoreDataHelper.retrieveClothing()
//        print(clothingData)
        if(clothingData.count == 0){
            guard let longitude = longitude else {
                print("No Long")
                return}
            guard let latitude = latitude else {
                print("No Lat")
                return}
            
            guard let toDate = toDate else {return}
            print(longitude)
            print(latitude)
            //        guard let gender = gender else {return}
            let weatherURL = ConstructAPILink.constructWeatherLink(latitude: latitude, longitude: longitude, toDate: toDate)
            let locationURL = ConstructAPILink.constructLocationLink(latitude: latitude, longitude: longitude)
            WeatherService.getWeather(url: weatherURL) { (temp) in
                let clothes = ClothingModelLogic.getClothing(temp: temp, gender:self.gender)
                let defaults = UserDefaults.standard
                let roundedTemp = Int(temp)
                defaults.set(roundedTemp, forKey: "temperature")
                
                
                let sanitizedWeatherTemp = String(roundedTemp) + "º"
                
                self.temperatureLabel.text = "\(sanitizedWeatherTemp)"
                
                var clothingItemArray = [Clothing]()
                for item in clothes {
                    let clothingItem = CoreDataHelper.newClothingItem()
                    clothingItem.title = item
                    clothingItemArray.append(clothingItem)
                }
                CoreDataHelper.saveClothing()
                self.clothingData = clothingItemArray
                self.tableView.reloadData()
                
               
//                print(self.clothingData)
                
            }
            
            
            WeatherService.getLocation(url: locationURL) { (location) in
                self.locationLabel.text = location
                let defaults = UserDefaults.standard
                defaults.set(location, forKey: "location")
                
                //TODO: store in UserDefaults
            }
            // Hide the navigation bar on the this view controller
            
        }
        else{
            let defaults = UserDefaults.standard
            let temperature = defaults.integer(forKey: "temperature")
            temperatureLabel.text = String(temperature)+"º"
            let location = defaults.string(forKey:"location")
            //TODO: store in UserDefaults
            
            locationLabel.text = location
            tableView.reloadData()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard

        // Do any additional setup after loading the view, typically from a nib.

    }
    
    @IBAction func unwindToHomeViewController(segue:UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
 
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothesCell", for: indexPath) as! ClothesTableViewCell
       
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
        let borderColor = UIColor.white
        cell.layer.borderColor = borderColor.cgColor
        
       
        cell.delegate = self
        
//        if let btnChk = cell.contentView.viewWithTag(2) as? UIButton {
//            btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
//        }
//        if let btnDelete = cell.contentView.viewWithTag(3) as? UIButton {
//            btnDelete.addTarget(self, action: "deleteButtonPressed", for: .touchUpInside)
//        }
     
        let clothingItem = clothingData[indexPath.row]
        cell.configure(clothing: clothingItem)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingData.count
    }
        
    @objc func checkboxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    

  
    @IBAction func newTripButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey:"isFirstScreen")
       
        for item in clothingData {
            CoreDataHelper.deleteClothing(clothing: item)
        }
        CoreDataHelper.saveClothing()
       
     
        defaults.removeObject(forKey:"temperature")
        defaults.removeObject(forKey:"location")
        
        
        
        
        if let parentVC = self.presentingViewController {
             performSegue(withIdentifier:"unwindToStartTripViewController" , sender: nil)
        }else{
             performSegue(withIdentifier:"showTripViewController" , sender: nil)
        }
       
       
       
    }
    
    
    
    

  
    
    
    
    
    


}

extension HomeViewController: ClothingTableViewCellDelegate {
    
    func clothing(_ cell: ClothesTableViewCell, didTapOn checkButton: UIButton) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return assertionFailure("cell not found for the tapped button \(checkButton) inside this cell \(cell)")
        }
        
        let selectedClothingItem = clothingData[indexPath.row]
        selectedClothingItem.isChecked = checkButton.isSelected
        CoreDataHelper.saveClothing()
    }
}

