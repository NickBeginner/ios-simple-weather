//
//  WeatherManager.swift
//  SimpleWeather
//
//  Created by Nicolo Belcastro on 29/12/21.
//

import Foundation
import CoreLocation

struct WeatherManager {
  
  // MARK: - Urls
  
  let baseURL =  "https://api.openweathermap.org/data/2.5/weather?appid=36ac40be5f4c80885c5f20a5c6a6217c&units=metric"
  
  // MARK: - Delegate
  
  var weatherDelegate: WeatherManagerDelegate?
  
  // MARK: - Fetching Functions
  
  func fetchWeather(cityName: String? = nil, latitude: CLLocationDegrees? = nil, longitude: CLLocationDegrees? = nil) {
    if let cityName = cityName {
      let urlString = "\(baseURL)&q=\(cityName)"
      performRequest(with: urlString)
    } else {
      fetchWeather(latitude: latitude, longitude: longitude)
    }
  }
  
  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
    performRequest(with: urlString)
  }
  
  // MARK: - Perform Request
  
  func performRequest(with url: String) {
    if let url = URL(string: url) {
      
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          self.weatherDelegate?.didFailWithError(error: error!)
          
          return
        }
        
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            self.weatherDelegate?.didUpdateWeather(self, weather: weather)
          }
        }
    }
    task.resume()
  }
}
  
  // MARK: - JSON Parsing
  
  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    
    do {
      let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodeData.weather[0].id
      let temp = decodeData.main.temp
      let name = decodeData.name
      
      let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
      return weather
      
    } catch {
      self.weatherDelegate?.didFailWithError(error: error)
      return nil
    }
  }
}
