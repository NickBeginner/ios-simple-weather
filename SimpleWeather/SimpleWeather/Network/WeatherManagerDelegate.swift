//
//  WeatherManagerDelegate.swift
//  SimpleWeather
//
//  Created by Nicolo Belcastro on 29/12/21.
//

import Foundation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}
