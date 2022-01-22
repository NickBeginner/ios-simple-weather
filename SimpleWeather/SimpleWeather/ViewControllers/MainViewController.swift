//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Nicolo Belcastro on 29/12/21.
//

import UIKit
import TinyConstraints
import CoreLocation

class MainViewController: UIViewController {
  
  // MARK: - UI Elements
  
  let mainView = MainView(frame: .zero)
  
  // MARK: - Delegate
  
  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(mainView)
    setConstraints()
    
    // Set the View controller as delegate
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
    locationManager.startUpdatingLocation()
    weatherManager.weatherDelegate = self
    self.mainView.searchTextField.delegate = self
    }
}
// MARK: - Constraints

private extension MainViewController {
  private func setConstraints() {
    mainView.edgesToSuperview()
  }
}

// MARK: - TextFieldDelegate

extension MainViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    mainView.searchTextField.endEditing(true)
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let city = self.mainView.searchTextField.text {
      weatherManager.fetchWeather(cityName: city)
    }
  }
}

// MARK: - WeatherManagerDelegate

extension MainViewController: WeatherManagerDelegate {
  
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
    DispatchQueue.main.async {
      if (self.mainView.degreesLabel.isHidden || self.mainView.cityLabel.isHidden) {
        self.mainView.cityLabel.isHidden = false
        self.mainView.degreesLabel.isHidden = false
        self.mainView.errorLabel.isHidden = true
      }
      self.mainView.degreesLabel.text = weather.temperatureString
      self.mainView.weatherImageVIew.image = UIImage(named: weather.conditionName)
      self.mainView.cityLabel.text = weather.cityName
    }
  }
  
  func didFailWithError(error: Error) {
    DispatchQueue.main.async {
      self.mainView.cityLabel.isHidden = true
      self.mainView.degreesLabel.isHidden = true
      self.mainView.errorLabel.isHidden = false
      self.mainView.errorLabel.text = self.setStringError(error)
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last{
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      weatherManager.fetchWeather(latitude: lat, longitude: lon)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

// MARK: - Error Manager

extension MainViewController {
  
  func setStringError(_ error: Error ) -> String {
    var errorString = "\(error)"
    if (errorString.contains("No value associated with key")) {
      errorString = "We haven't found the city you're looking for."
    }
    return errorString
  }
}
