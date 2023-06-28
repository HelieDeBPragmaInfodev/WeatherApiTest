//
//  AddCityViewModel.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 27/06/2023.
//

import Foundation

final class AddCityViewModel {
    
    fileprivate let coreDataManager = CoreDataManager()
    
    /// Save a new city into the main list into core data base, and close th modal AddCityViewController
    /// - Parameters:
    ///   - city: The city the user want to get the weather data
    /// - Returns: A completion block indicating the end of the treatment
    public func saveNewCity(city: City, completion: () -> ()) {
        
        coreDataManager.saveNewCity(city: city) { citySavedSuccessfully in
            if !citySavedSuccessfully {
                print("An error occured while saving new city")
            }
            completion()
        }
        
    }
}
