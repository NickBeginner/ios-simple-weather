//
//  MainView.swift
//  SimpleWeather
//
//  Created by Nicolo Belcastro on 29/12/21.
//

import UIKit
import TinyConstraints

final class MainView: UIView {
  
  // MARK: - UIElements
  
  // The 'UIImageView' containing icons about the wather conditions
  let weatherImageVIew = UIImageView()
  
  // The label displaying the temperature
  let degreesLabel = UILabel()
  
  // The label displaying the name of the city
  let cityLabel = UILabel()
  
  // The Text Field that allows the user to search a location
  let searchTextField = UITextField()
  
  // The Button that allows to start a research
  let searchButton = UIButton()
  
  // The Button that fetch the GPS Location
  let locationButton = UIButton()
  
  // The label that displays errors
  let errorLabel = UILabel()
  
  // MARK: Interactions
  
  var didTapSearchButton: Interaction?
  
  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - SSL
  
  func setup() {
    addSubview(weatherImageVIew)
    addSubview(degreesLabel)
    addSubview(cityLabel)
    addSubview(searchTextField)
    addSubview(searchButton)
    addSubview(locationButton)
    addSubview(errorLabel)
    
    searchButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedSearchButton)))
  }
  
  func style() {
    self.backgroundColor = .white
    Self.styleMainViewLabels(entries: [degreesLabel,cityLabel])
    Self.styleSearchTextField(searchTextField)
    Self.styleSearchButton(searchButton)
    Self.styleErrorLabel(errorLabel)
  }
  
  func layout() {
    Self.layoutWeatherImageView(weatherImageVIew)
    Self.layoutSearchTextField(searchTextField, weatherImageVIew)
    Self.layoutSearchButton(searchButton)
    Self.layoutCityLabel(cityLabel, searchTextField)
    Self.layoutDegreesLabel(degreesLabel, cityLabel, searchTextField)
    Self.layoutErrorLabel(errorLabel, searchTextField)
  }
}
// MARK: - Styling Functions

private extension MainView {
  static func styleMainViewLabels(entries: [UILabel]) {
    for entry in entries {
      entry.textColor = .darkGray
      entry.font = UIFont(name: "helvetica" ,size: 30)
      entry.textAlignment = NSTextAlignment.center
    }
  }
  
  static func styleSearchTextField(_ textField: UITextField) {
    textField.borderStyle = .roundedRect
    textField.textColor = .darkGray
    textField.placeholder = "Search a city"
  }
  
  static func styleSearchButton(_ button: UIButton) {
    button.backgroundColor = .lightGray
    button.layer.cornerRadius = 12
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Search", for: .normal)
  }
  
  static func styleErrorLabel(_ label: UILabel) {
    label.textColor = .red
    label.font = UIFont(name: "helvetica", size: 15)
  }
  
  static func animateSearchButton(_ button: UIButton) {
    UIView.animate(withDuration: 0.1, animations: {
      button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    },completion: { _ in
        UIView.animate(withDuration: 0.1) {
          button.transform = CGAffineTransform.identity
      }
    })
  }
}

// MARK: - Layout Functions

private extension MainView {
  static func layoutWeatherImageView(_ imageView: UIImageView) {
    imageView.width(350)
    imageView.height(130)
    imageView.topToSuperview(offset: 50, usingSafeArea: true)
    imageView.centerXToSuperview()
  }
  
  static func layoutCityLabel(_ label: UILabel, _ sibling: UITextField) {
    label.top(to: sibling, offset: 70)
    label.centerXToSuperview(offset: -80)
  }
  
  static func layoutDegreesLabel(_ label: UILabel, _ sibling: UILabel, _ secondSibling: UITextField) {
    label.top(to: secondSibling, offset: 70)
    label.right(to: sibling, offset: 160)
  }
  
  static func layoutSearchTextField(_ textField: UITextField, _ sibling: UIImageView) {
    textField.width(350)
    textField.centerXToSuperview()
    textField.top(to: sibling, offset: 150)
  }
  
  static func layoutSearchButton(_ button: UIButton) {
    button.width(350)
    button.height(50)
    button.centerXToSuperview()
    button.bottomToSuperview(offset: -5, usingSafeArea: true)
  }
  
  static func layoutErrorLabel(_ label: UILabel, _ sibling: UITextField) {
    label.centerXToSuperview()
    label.top(to: sibling, offset: 70)
  }
}

// MARK: - Helpers

private extension MainView {
  
  @objc func tappedSearchButton() {
    didTapSearchButton?()
    Self.animateSearchButton(self.searchButton)
    self.searchTextField.endEditing(true)
    self.searchTextField.text = nil
  }
}
