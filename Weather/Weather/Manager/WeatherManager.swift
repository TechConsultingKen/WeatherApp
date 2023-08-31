//
//  WeatherManager.swift
//  Weather
//
//  Created by Consultant on 8/29/23.
//

import Foundation
import CoreLocation

protocol NetworkStuff{
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> CurrentData
    
    func getForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> FiveDayData
}


class WeatherManager:NetworkStuff {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> CurrentData {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=ea2921f5ea15080148ad510d9afae945") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather date")}
        
        let decodedData = try JSONDecoder().decode(CurrentData.self, from: data)
        
        return decodedData
    }
    
    func getForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> FiveDayData {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=ea2921f5ea15080148ad510d9afae945") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather date")}
        
        let decodedData = try JSONDecoder().decode(FiveDayData.self, from: data)
        
        return decodedData
    }
}
