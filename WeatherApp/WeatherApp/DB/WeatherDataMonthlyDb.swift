//
//  WeatherDataMonthlyDb.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.02.2022.
//

import Foundation
import RealmSwift

@objcMembers class WeatherDataDayDetailsCached: Object {
    dynamic var date: Double?
    dynamic var temperatureDay: Int?
    dynamic var temperatureNight: Int?
    dynamic var feelsLikeDay: Int?
    dynamic var feelsLikeNight: Int?
    dynamic var windSpeed: Float?
    dynamic var humidity: Int?
    dynamic var clouds: Int?
    dynamic var weatherDescription: String?
    dynamic var moonset: Double?
    dynamic var moonrise: Double?
    dynamic var sunset: Double?
}


@objcMembers class WeatherDataMonthlyCached: Object {
    dynamic var poi: String?
    dynamic var lon: Float?
    dynamic var lat: Float?
    
    let days = RealmSwift.List<WeatherDataDayDetailsCached>()

    override static func primaryKey() -> String? {
        return "poi"
    }
}

class WeatherDataMonthlyDbProvider {
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather_data_monthly.realm")
        realm = try? Realm(configuration: config)
    }
            
    func getMonthlyWeatherDataForPoi(poi : String) -> WeatherDataMonthly? {
        let weatherData = realm?.object(ofType: WeatherDataMonthlyCached.self, forPrimaryKey: poi)
        if let weatherData = weatherData {
            let result = WeatherDataMonthly()
            result.lat = weatherData.lat ?? 0.0
            result.lon = weatherData.lon ?? 0.0
            result.days = weatherData.days.map { item in
                let result = WeatherDataDayDetails()
                result.date = item.date ?? 0.0
                result.temperatureDay = item.temperatureDay ?? 0
                result.temperatureNight = item.temperatureNight ?? 0
                result.feelsLikeDay = item.feelsLikeDay ?? 0
                result.feelsLikeNight = item.feelsLikeNight ?? 0
                result.windSpeed = item.windSpeed ?? 0.0
                result.humidity = item.humidity ?? 0
                result.clouds = item.clouds ?? 0
                result.weatherDescription = item.weatherDescription ?? ""
                result.moonset = item.moonset ?? 0.0
                result.moonrise = item.moonrise ?? 0.0
                result.sunset = item.sunset ?? 0.0
                return result
            }
            return result
        } else {
            return nil
        }
    }
    
    func addMonthlyWeatherDataForPoi(poi : String, weatherData: WeatherDataMonthly) {
        let cachedWeatherData = WeatherDataMonthlyCached()
        cachedWeatherData.poi = poi
        cachedWeatherData.lat = weatherData.lat
        cachedWeatherData.lon = weatherData.lon
        weatherData.days.forEach { item in
            let result = WeatherDataDayDetailsCached()
            result.date = item.date
            result.temperatureDay = item.temperatureDay
            result.temperatureNight = item.temperatureNight
            result.feelsLikeDay = item.feelsLikeDay
            result.feelsLikeNight = item.feelsLikeNight
            result.windSpeed = item.windSpeed
            result.humidity = item.humidity
            result.clouds = item.clouds
            result.weatherDescription = item.weatherDescription
            result.moonset = item.moonset
            result.moonrise = item.moonrise
            result.sunset = item.sunset

            cachedWeatherData.days.append(result)
        }
        
        if isWeatherDataExist(poi: poi) {
            try? realm?.write {
                realm?.add(cachedWeatherData, update: .modified)
            }
        } else {
            try? realm?.write {
                realm?.add(cachedWeatherData)
            }
        }
    }
        
    func isWeatherDataExist(poi: String) -> Bool {
        return realm?.object(ofType: WeatherDataMonthlyCached.self, forPrimaryKey: poi) != nil
    }
}

class WeatherDataMonthlyDB {
    private let dbDataProvider : WeatherDataMonthlyDbProvider = WeatherDataMonthlyDbProvider()
    
    static var shared: WeatherDataMonthlyDB = {
        let instance = WeatherDataMonthlyDB()
        return instance
    }()

    private init() {}
    
    func getMonthlyWeatherDataForPoi(poi : String) -> WeatherDataMonthly? {
        return dbDataProvider.getMonthlyWeatherDataForPoi(poi: poi)
    }
    
    func addMonthlyWeatherDataForPoi(poi : String, weatherData: WeatherDataMonthly) {
        return dbDataProvider.addMonthlyWeatherDataForPoi(poi: poi, weatherData: weatherData)
    }
}

