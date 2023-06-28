//
//  WeatherAPINetworkService.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 27/06/2023.
//

import Foundation
import Combine

final class WeatherAPINetworkService {
    
    fileprivate let apiKey = "8f9d9142da86205bac2ddbcefb8b0467"
    
    fileprivate var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    /// Fetch weather data from the OpenWeatherApi for a GPS coordinate
    /// - Parameters:
    ///   - city: The City from the mocked list for this test, containing the lat and long we need to get the ressource from the api
    /// - Returns: A completion blocks with an optional WeatherAPIResponse with the data we need to display the weather to the user
    public func fetchWeatherData(_with city: CDCity, completionHandler: @escaping (WeatherAPIResponse?) -> ()) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(city.lat)&lon=\(city.long)&units=metric&appid=8f9d9142da86205bac2ddbcefb8b0467") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeatherAPIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Request completed successfully")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(nil)
                }
            }, receiveValue: { responseData in
                print("Received response data: \(responseData)")
                completionHandler(responseData)
            })
            .store(in: &cancellables)
    }
}



