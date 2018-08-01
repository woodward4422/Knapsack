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
    var clothes = [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let longitude = longitude else {return}
        guard let latitude = latitude else {return}
        let weatherURL = ConstructAPILink.constructWeatherLink(latitude: latitude, longitude: longitude)
        let locationURL = ConstructAPILink.constructLocationLink(latitude: latitude, longitude: longitude)
        WeatherService.getWeather(url: weatherURL) { (temp) in
           let roundedTemp = Int(temp)
            let sanitizedWeatherTemp = String(roundedTemp) + "º"
            
            self.temperatureLabel.text = "\(sanitizedWeatherTemp)"
            self.clothes = ClothingModel.getClothing()
            print(self.clothes)
            self.tableView.reloadData()
        }
        
    
        WeatherService.getLocation(url: locationURL) { (location) in
            self.locationLabel.text = location
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "clothesCell", for: indexPath) as! ClothesTableViewCell
        let clothingItem = clothes[indexPath.row]
        cell.clothesLabel.text = clothingItem
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothes.count
    }
        
        
  
   


}
