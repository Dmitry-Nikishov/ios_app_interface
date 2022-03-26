//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 03.02.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherClient {
    private let apiKey = "d1348bb770bbb926275e46b561bf3abb"
    private let oneDayUrl = "http://api.openweathermap.org/data/2.5/weather"
    private let hourlyUrl = "https://api.openweathermap.org/data/2.5/onecall?exclude=current,minutely,daily,alerts&"
    private let monthUrl = "https://api.openweathermap.org/data/2.5/onecall?exclude=current,minutely,hourly,alerts&"
    
    static var shared: WeatherClient = {
        let instance = WeatherClient()
        return instance
    }()

    private init() {}
    
    private func extractMonthlyWeatherFrom(json: JSON) -> WeatherDataMonthly? {
        let res = WeatherDataMonthly()
        res.lon = json["lon"].floatValue
        res.lat = json["lat"].floatValue
        for (_,item) in json["daily"] {
            let day = WeatherDataDayDetails()
            day.date = item["dt"].doubleValue
            day.temperatureDay = Int(item["temp"]["day"].doubleValue - 273.15)
            day.temperatureNight = Int(item["temp"]["night"].doubleValue - 273.15)
            day.feelsLikeDay = Int(item["feels_like"]["day"].doubleValue - 273.15)
            day.feelsLikeNight = Int(item["feels_like"]["night"].doubleValue - 273.15)
            day.windSpeed = item["wind_speed"].floatValue
            day.humidity = item["humidity"].intValue
            day.clouds = item["clouds"].intValue
            day.weatherDescription = item["weather"][0]["description"].stringValue
            day.moonset = item["moonset"].doubleValue
            day.moonrise = item["moonrise"].doubleValue
            day.sunset = item["sunset"].doubleValue
            day.sunrise = item["sunrise"].doubleValue
            day.uvi = item["uvi"].intValue
            res.days.append(day)
        }

        return res
    }
    
    private func extractHourlyWeatherFrom(json: JSON) -> WeatherDataHourly? {
        let res = WeatherDataHourly()
        res.lon = json["lon"].floatValue
        res.lat = json["lat"].floatValue
        for (_,item) in json["hourly"] {
            if res.hourly.count == 24 { break }
            let hour = WeatherDataHourDetails()
            hour.date = item["dt"].doubleValue
            hour.temperature = Int(item["temp"].doubleValue - 273.15)
            hour.feelsLike = Int(item["feels_like"].doubleValue - 273.15)
            hour.windSpeed = item["wind_speed"].floatValue
            hour.humidity = item["humidity"].intValue
            hour.clouds = item["clouds"].intValue
            res.hourly.append(hour)
        }

        return res
    }
    
    private func extractOneDayWeatherFrom(json: JSON) -> WeatherDataOneDay? {
        if let tempResult = json["main"]["temp"].double,
           let feelsLikeResult = json["main"]["feels_like"].double {
            let weatherDataModel = WeatherDataOneDay()
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.temperatureDescription = json["weather"][0]["description"].stringValue
            weatherDataModel.sunset = json["sys"]["sunset"].doubleValue
            weatherDataModel.sunrise = json["sys"]["sunrise"].doubleValue
            weatherDataModel.clouds = json["clouds"]["all"].intValue
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.windSpeed = json["wind"]["speed"].floatValue
            weatherDataModel.date = json["dt"].doubleValue
            weatherDataModel.feelsLike = Int(feelsLikeResult - 273.15)
            weatherDataModel.lon = json["coord"]["lon"].floatValue
            weatherDataModel.lat = json["coord"]["lat"].floatValue
            return weatherDataModel
        } else {
            return nil
        }
    }

    func getOneDayForecast(latitude: String,
                           longitude: String,
                           dataHandler: @escaping OneDayWeatherDataHandler)
    {
        let params: [String : String] = ["lat": latitude, "lon": longitude, "appid": apiKey]
        
        AF.request(oneDayUrl, method: HTTPMethod.get, parameters: params).responseJSON(queue: DispatchQueue.global(qos: .utility)) { [weak self] response in
            switch response.result {
            case .success(let value):
                let weatherJSON : JSON = JSON(value)
                if weatherJSON["cod"] == "404" {
                    dataHandler(nil)
                } else {
                    let weather = self?.extractOneDayWeatherFrom(json: weatherJSON)
                    dataHandler(weather)
                }
            case .failure(let error):
                print("Ошибка при запросе на получение погоды \(error)")
                dataHandler(nil)
            }
        }
    }
    
    func getHourlyForecast(latitude: String,
                           longitude: String,
                           dataHandler : @escaping HourlyWeatherDataHandler)
    {
        let params: [String : String] = ["lat": latitude, "lon": longitude, "appid": apiKey]
        
        AF.request(hourlyUrl, method: HTTPMethod.get, parameters: params).responseJSON(queue: DispatchQueue.global(qos: .utility) ) { [weak self] response in
            switch response.result {
            case .success(let value):
                let weatherJSON : JSON = JSON(value)
                if weatherJSON["cod"] == "404" {
                    dataHandler(nil)
                } else {
                    let weather = self?.extractHourlyWeatherFrom(json: weatherJSON)
                    dataHandler(weather)
                }
            case .failure(let error):
                print("Ошибка при запросе на получение погоды \(error)")
                dataHandler(nil)
            }
        }
    }

    func getMonthlyForecast(latitude: String,
                           longitude: String,
                           dataHandler : @escaping MonthlyWeatherDataHandler)
    {
        let params: [String : String] = ["lat": latitude, "lon": longitude, "appid": apiKey]
        
        AF.request(monthUrl, method: HTTPMethod.get, parameters: params).responseJSON(queue: DispatchQueue.global(qos: .utility) ) { [weak self] response in
            switch response.result {
            case .success(let value):
                let weatherJSON : JSON = JSON(value)
                if weatherJSON["cod"] == "404" {
                    dataHandler(nil)
                } else {
                    let weather = self?.extractMonthlyWeatherFrom(json: weatherJSON)
                    dataHandler(weather)
                }
            case .failure(let error):
                print("Ошибка при запросе на получение погоды \(error)")
                dataHandler(nil)
            }
        }
    }
}
