//
//  WeatherDataHourlyDb.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.02.2022.
//

import Foundation
import RealmSwift

@objcMembers class WeatherDataHourDetailsCached: Object {
    dynamic var date: Double = 0
    dynamic var temperature: Int = 0
    dynamic var feelsLike: Int = 0
    dynamic var windSpeed: Float = 0.0
    dynamic var humidity: Int = 0
    dynamic var clouds: Int = 0
}

@objcMembers class WeatherDataHourlyCached: Object {
    dynamic var poi: String?
    dynamic var lon: Float?
    dynamic var lat: Float?
    
    let hourly = RealmSwift.List<WeatherDataHourDetailsCached>()

    override static func primaryKey() -> String? {
        return "poi"
    }
}

class WeatherDataHourlyDbProvider {
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather_data_hourly.realm")
        realm = try? Realm(configuration: config)
    }
            
    func getHourlyWeatherDataForPoi(poi : String) -> WeatherDataHourly? {
        let weatherData = realm?.object(ofType: WeatherDataHourlyCached.self, forPrimaryKey: poi)
        if let weatherData = weatherData {
            let result = WeatherDataHourly()
            result.lat = weatherData.lat ?? 0.0
            result.lon = weatherData.lon ?? 0.0
            result.hourly = weatherData.hourly.map { item in
                let result = WeatherDataHourDetails()
                result.clouds = item.clouds
                result.feelsLike = item.feelsLike
                result.windSpeed = item.windSpeed
                result.humidity = item.humidity
                result.temperature = item.temperature
                result.date = item.date
                return result
            }
            return result
        } else {
            return nil
        }
    }
    
    func addHourlyWeatherDataForPoi(poi : String, weatherData: WeatherDataHourly) {
        let cachedWeatherData = WeatherDataHourlyCached()
        cachedWeatherData.poi = poi
        cachedWeatherData.lat = weatherData.lat
        cachedWeatherData.lon = weatherData.lon
        weatherData.hourly.forEach { item in
            let result = WeatherDataHourDetailsCached()
            result.clouds = item.clouds
            result.feelsLike = item.feelsLike
            result.windSpeed = item.windSpeed
            result.humidity = item.humidity
            result.temperature = item.temperature
            result.date = item.date
            
            cachedWeatherData.hourly.append(result)
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
        return realm?.object(ofType: WeatherDataHourlyCached.self, forPrimaryKey: poi) != nil
    }
}

class WeatherDataHourlyDB {
    private let dbDataProvider : WeatherDataHourlyDbProvider = WeatherDataHourlyDbProvider()
    
    static var shared: WeatherDataHourlyDB = {
        let instance = WeatherDataHourlyDB()
        return instance
    }()

    private init() {}
    
    func getHourlyWeatherDataForPoi(poi : String) -> WeatherDataHourly? {
        return dbDataProvider.getHourlyWeatherDataForPoi(poi: poi)
    }
    
    func addHourlyWeatherDataForPoi(poi : String, weatherData: WeatherDataHourly) {
        return dbDataProvider.addHourlyWeatherDataForPoi(poi: poi, weatherData: weatherData)
    }
}
