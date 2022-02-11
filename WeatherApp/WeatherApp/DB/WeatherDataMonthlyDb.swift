//
//  WeatherDataMonthlyDb.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.02.2022.
//

import Foundation
import RealmSwift

class WeatherDataDayDetailsCached: Object {
    @objc dynamic var date: Double = 0
    @objc dynamic var temperatureDay: Int = 0
    @objc dynamic var temperatureNight: Int = 0
    @objc dynamic var feelsLikeDay: Int = 0
    @objc dynamic var feelsLikeNight: Int = 0
    @objc dynamic var windSpeed: Float = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var clouds: Int = 0
    @objc dynamic var weatherDescription: String = ""
    @objc dynamic var moonset: Double = 0
    @objc dynamic var moonrise: Double = 0
    @objc dynamic var sunset: Double = 0
}

class WeatherDataMonthlyCached: Object {
    @objc dynamic var poi: String = ""
    @objc dynamic var lon: Float = 0
    @objc dynamic var lat: Float = 0
    
    let days = RealmSwift.List<WeatherDataDayDetailsCached>()

    override static func primaryKey() -> String? {
        return "poi"
    }
}

class WeatherDataMonthlyDbProvider {
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(AppCommonStrings.appRealmDbName)
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

