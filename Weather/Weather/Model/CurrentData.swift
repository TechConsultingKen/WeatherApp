//
//  CurrentData.swift
//  Weather
//
//  Created by Consultant on 8/29/23.
//

import Foundation

struct CurrentData: Codable {
    let weather: [CurrentWeather]?
    let main: Main?
    let name: String?
    
}
// MARK: - Main
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double?
        let pressure, humidity, seaLevel, grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }

struct CurrentWeather: Codable {
    let id: Int?
    let description, icon: String?
}
