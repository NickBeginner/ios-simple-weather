//
//  WeatherModel.swift
//  SimpleWeather
//
//  Created by Nicolo Belcastro on 29/12/21.
//

import Foundation

struct WeatherModel {
  let conditionID: Int
  let cityName: String
  let temperature: Double
  
  var conditionName: String {
    switch conditionID {
    case 200...232:
      return "storm"
    case 300...321:
      return "drizzle"
    case 500...531:
      return "rain"
    case 600...622:
      return "snow"
    case 701...781:
      return "fog"
    case 800:
      return "sun"
    case 801...804:
      return "storm"
    default:
            return "cloud"
    }
  }
  
  var temperatureString: String {
    return String(format: "%.1f", temperature)
  }
}
