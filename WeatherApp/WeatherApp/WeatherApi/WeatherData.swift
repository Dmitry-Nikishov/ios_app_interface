//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 03.02.2022.
//

import Foundation

class WeatherDataOneDay {
    var temperature: Int = 0
    var temperatureDescription: String = ""
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var sunset: Double = 0
    var sunrise: Double = 0
    var humidity: Int = 0
    var windSpeed: Float = 0.0
    var date: Double = 0
    var feelsLike: Int = 0
    
    var clouds: Int = 0
    var lon: Float = 0.0
    var lat: Float = 0.0
    
    func printSelf()
    {
        print("temperature : \(temperature)")
        print("temperatureDescription : \(temperatureDescription)")
        print("condition : \(condition)")
        print("city : \(city)")
        print("weatherIconName : \(weatherIconName)")
        print("sunset : \(sunset)")
        print("sunrise : \(sunrise)")
        print("humidity : \(humidity)")
        print("windSpeed : \(windSpeed)")
        print("date : \(date)")
        print("feelsLike : \(feelsLike)")
        print("clouds : \(clouds)")
        print("lon : \(lon)")
        print("lat : \(lat)")
    }
}

class WeatherDataHourDetails {
    var date: Double = 0
    var temperature: Int = 0
    var feelsLike: Int = 0
    var windSpeed: Float = 0.0
    var humidity: Int = 0
    var clouds: Int = 0
}

class WeatherDataHourly {
    var lon: Float = 0.0
    var lat: Float = 0.0
    var hourly: [WeatherDataHourDetails] = []
}

class WeatherDataDayDetails {
    var date: Double = 0
    var temperatureDay: Int = 0
    var temperatureNight: Int = 0
    var feelsLikeDay: Int = 0
    var feelsLikeNight: Int = 0
    var windSpeed: Float = 0.0
    var humidity: Int = 0
    var clouds: Int = 0
    var weatherDescription: String = ""
    var moonset: Double = 0
    var moonrise: Double = 0
    var sunset: Double = 0
    var sunrise : Double = 0
    var uvi : Int = 0
}

class WeatherDataMonthly {
    var lon: Float = 0.0
    var lat: Float = 0.0
    var days: [WeatherDataDayDetails] = []
}


