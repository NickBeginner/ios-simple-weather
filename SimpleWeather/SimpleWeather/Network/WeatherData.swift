//
//  WeatherData.swift
//  SimpleWeather
//
//  Created by Nicolo Belcastro on 29/12/21.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id:Int
}
