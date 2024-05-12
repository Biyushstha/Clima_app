//
//  ViewController.swift
//  Clima
//  Created by Biyush on 04/03/2024.

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatheraManager()
    let locationmanager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationmanager.requestLocation()
    }
    
}

//MARK: - CLLocationManager

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationmanager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longtitute: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Please type something!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            
            weatherManager.fetchWeather(cityName: city)
            
        }
        searchTextField.text = ""
    }
}
//MARK: - WeatherManagerDelegeate

extension  WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManger: WeatheraManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempratureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error")
    }
    
}
