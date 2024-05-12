//
//  File.swift
//  Clima
//
//  Created by Biyush on 04/03/2024.


import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main:Codable {
    let temp: Double
}
struct Weather: Codable {
    let id : Int
}


