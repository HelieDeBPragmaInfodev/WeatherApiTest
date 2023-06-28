//
//  WeatherAPIViewModel.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 27/06/2023.
//

import Foundation

final class WeatherAPIViewModel {
    
    fileprivate let citiesAvailable : [City] = [City(name: "Paris", lat: 48.864716, long: 2.349014, temp: "--", description: "--", iconName: ""), City(name: "San Francisco", lat: 37.773972, long: -122.431297, temp: "--", description: "--", iconName: ""), City(name: "London", lat: 51.509865, long: -0.118092, temp: "--", description: "--", iconName: "")]
    
    fileprivate let coreDataManager = CoreDataManager()
    fileprivate let weatherAPINetworkService = WeatherAPINetworkService()
    fileprivate var fetchCounter: Int = 0
    
    public var citiesStored: [CDCity] = []
    
    /// Load all stored cities from Core Data base
    /// - Parameters:
    ///   - none: It's a fetch all element
    /// - Returns: An optional completion block indicating the end of the fetch
    public func loadStoredCities(completion: (() -> ())? = nil) {
        citiesStored = coreDataManager.loadAllCitiesStored()
        if let completion {
            completion()
        }
    }
    
    /// Delete a city from the core data Base
    /// - Parameters:
    ///   - city: The city the user want to delete
    /// - Returns: An optional completion block indicating the end of the treatment
    public func deleteCity(city: CDCity, completion: ((Bool) -> ())? = nil) {
        coreDataManager.deleteSelectedCity(city: city, completion: completion)
    }
    
    /// An helper function to retreive the list of city the user didn't add to the main list before
    /// - Parameters:
    ///   - none:
    /// - Returns: The filtered list of city the user can add to the main list
    public func getListOfCitiesToAdd() -> [City] {
        let filteredNames: [String?] = citiesStored.map { $0.name }
        var citiesFiltered : [City] = citiesAvailable
        for filter in filteredNames {
            citiesFiltered.removeAll(where: { $0.name == filter})
        }
        return citiesFiltered
    }
    
    /// Fetch weather data for the all stored cities
    /// - Parameters:
    ///   - none:
    /// - Returns: nothing
    public func fetchWeatherDataForStoredLocalization() {
        guard fetchCounter == 0 else {
            return
        }
        fetchCounter = citiesStored.count
        for city in citiesStored {
            fetchWeatherDataForCity(city: city)
        }
    }
    
    /// Fetch weather data for a specific city
    /// - Parameters:
    ///   - city: The city the user want to get the weather data
    /// - Returns: nothing
    fileprivate func fetchWeatherDataForCity(city: CDCity) {
        weatherAPINetworkService.fetchWeatherData(_with: city) { [weak self] weatherApiResponse in
            guard let self else { return }
            if let weatherApiResponse {
                city.iconName = weatherApiResponse.weather[0].icon
                city.temp = String(Int(weatherApiResponse.main.temp))
                city.descriptionWeather = weatherApiResponse.weather[0].main
                self.coreDataManager.updateCity(city: city) { isCityUpdated in
                    if isCityUpdated {
                        print("City \(city.name ?? "") updated successfully")
                        NotificationCenter.default.post(name: Notification.Name("NewCityWeatherUpdated"), object: nil)
                        self.fetchCounter -= 1
                        if self.fetchCounter == 0 {
                            NotificationCenter.default.post(name: Notification.Name("FetchAllCitiesWeatherDone"), object: nil)
                        }
                    }
                }
            }
        }
    }
}
