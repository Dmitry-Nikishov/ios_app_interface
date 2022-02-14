//
//  WeatherDataHourlyDb.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.02.2022.
//

import Foundation
import RealmSwift

class WeatherDataHourDetailsCached: Object {
    @objc dynamic var date: Double = 0
    @objc dynamic var temperature: Int = 0
    @objc dynamic var feelsLike: Int = 0
    @objc dynamic var windSpeed: Float = 0.0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var clouds: Int = 0
}

class WeatherDataHourlyCached: Object {
    @objc dynamic var poi: String = ""
    @objc dynamic var lon: Float = 0
    @objc dynamic var lat: Float = 0
    
    let hourly = RealmSwift.List<WeatherDataHourDetailsCached>()

    override static func primaryKey() -> String? {
        return "poi"
    }
}

class WeatherDataHourlyDbProvider {
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(AppCommonStrings.appRealmDbName)
        realm = try? Realm(configuration: config)
    }
            
    func getHourlyWeatherDataForPoi(poi : String) -> WeatherDataHourly? {
        let weatherData = realm?.object(ofType: WeatherDataHourlyCached.self, forPrimaryKey: poi)
        if let weatherData = weatherData {
            let result = WeatherDataHourly()
            result.lat = weatherData.lat
            result.lon = weatherData.lon
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
