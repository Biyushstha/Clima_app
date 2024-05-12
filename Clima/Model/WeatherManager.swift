//
//  WeatherManager.swift
//  Clima
//
//  Created by Biyush on 04/03/2024.
//
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger: WeatheraManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatheraManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1e1f12c0d1e102f6fd811f9bd999672d&units=metric"
    
    func fetchWeather (cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    func fetchWeather (latitude: CLLocationDegrees, longtitute: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtitute)"
        performRequest(with: urlString)
        
        
    }
    
    func performRequest(with urlString: String){
        //1.create URL
        if let url = URL(string: urlString){
            //2.Create URL session
            DispatchQueue.global().async {
                let session = URLSession(configuration: .default)
                //3r.Give session a Task
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil{
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data{
                        if let weather = self.parseJason(safeData){
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
                //Start the task
                task.resume()
            }
        }
        
    }
    
    func parseJason(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(condtionID: id, cityName: name, temprature: temp)
            return weather
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
}
