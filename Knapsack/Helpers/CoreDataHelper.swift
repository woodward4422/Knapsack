//
//  CoreDataHelper.swift
//  Knapsack
//
//  Created by Noah Woodward on 8/1/18.
//  Copyright © 2018 Noah Woodward. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    // Clothing
    static func newClothingItem() -> Clothing {
        let clothing = NSEntityDescription.insertNewObject(forEntityName: "Clothing", into: context) as! Clothing
        return clothing
        
    }
    
    static func saveClothing() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteClothing(clothing: Clothing) {
        context.delete(clothing)
        saveClothing()
    }
    
    static func retrieveClothing() -> [Clothing] {
        let fetchRequest = NSFetchRequest<Clothing>(entityName: "Clothing")
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    
    //Temperature
    
    static func newTemperature() -> Temperature {
        let temperature = NSEntityDescription.insertNewObject(forEntityName: "Temperature", into: context) as! Temperature
        return temperature
        
    }
    
    static func saveTemperature() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteTemperature(temp: Temperature) {
        context.delete(temp)
       saveTemperature()
    }
    
    static func retrieveTemperature() -> [Temperature] {
        let fetchRequest = NSFetchRequest<Temperature>(entityName: "Temperature")
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    //Location
    
    static func newLocation() -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as! Location
        return location
        
    }
    
    static func saveLocation() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteLocation(location: Location) {
        context.delete(location)
        saveLocation()
    }
    
    static func retrieveLocation() -> [Location] {
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
}
