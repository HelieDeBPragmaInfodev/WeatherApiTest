//
//  CoreDataManager.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 27/06/2023.
//

import Foundation
import UIKit

final class CoreDataManager {
    
    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// Save a new City into Core Data
    /// - Parameters:
    ///   - city: The City from the mocked list for this test
    /// - Returns: A completion blocks with a Bool flag indicating if the city have been saved or not
    public func saveNewCity(city: City, completion: (Bool) -> ()) {
        let cityToSave = CDCity(context: context)
        cityToSave.name = city.name
        cityToSave.lat = Float(city.lat)
        cityToSave.long = Float(city.long)
        
        do {
            try context.save()
            print("successfully saved new city")
            completion(true)
        } catch {
            print("Could not save new city with error \(error)")
            completion(false)
        }
    }
    
    /// Update an existing City into Core Data
    /// - Parameters:
    ///   - city: The City retreived from core data and updated
    /// - Returns: A completion blocks with a Bool flag indicating if the city have been updated or not
    public func updateCity(city: CDCity, completion: (Bool) -> ()) {
        guard let cityName = city.name else {
            completion(false)
            return
        }
        let fetchRequest = CDCity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", cityName)
        do {
            let cities = try context.fetch(fetchRequest)
            guard cities.count > 0 else {
                completion(false)
                print("couldnt find the city to update")
                return
            }
            try context.save()
            completion(true)
            
        } catch {
            completion(false)
            print("couldnt fetch all cities stored")
        }
    }
    
    /// Fetch all cities stored in the Core Data base
    /// - Parameters:
    ///   - none: This method does not need any parameter
    /// - Returns: A list of Core Data City Object
    public func loadAllCitiesStored() -> [CDCity] {
        var allCitiesStored = [CDCity]()
        do {
            allCitiesStored =
            try context.fetch(CDCity.fetchRequest())
        } catch {
            print("couldnt fetch all cities stored")
        }
        return allCitiesStored
    }
    
    /// Delete an existing City into Core Data
    /// - Parameters:
    ///   - city: The City retreived from core data and the user want to delete
    /// - Returns: An optional completion blocks with a Bool flag indicating if the city have been deleted or not
    public func deleteSelectedCity(city: CDCity, completion: ((Bool) -> ())? = nil) {
        do {
            context.delete(city)
            try context.save()
            if let completion {
                completion(true)
            }
            print("successfully deleted old city")
        } catch {
            if let completion {
                completion(false)
            }
            print("Could not delete old city with error \(error)")
        }
    }
}
