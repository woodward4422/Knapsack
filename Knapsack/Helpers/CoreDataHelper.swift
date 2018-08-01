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
    
    static func deleteNote(clothing: Clothing) {
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
    
    
}
