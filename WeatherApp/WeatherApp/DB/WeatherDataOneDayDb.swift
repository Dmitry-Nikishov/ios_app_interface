//
//  WeatherDataOneDayDb.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.02.2022.
//

import Foundation
import RealmSwift

@objcMembers class WeatherDataOneDayCached: Object {
    dynamic var poi: String?
    
    dynamic var temperature: Int?
    dynamic var temperatureDescription: String?
    dynamic var condition: Int?
    dynamic var city: String?
    dynamic var weatherIconName: String?
    dynamic var sunset: Double?
    dynamic var sunrise: Double?
    dynamic var humidity: Int?
    dynamic var windSpeed: Float?
    dynamic var date: Double?
    dynamic var feelsLike: Int?
    dynamic var clouds: Int?
    dynamic var lon: Float?
    dynamic var lat: Float?

    override static func primaryKey() -> String? {
        return "poi"
    }
}

class WeatherDataOneDayDbProvider {
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather_data_one_day.realm")
        realm = try? Realm(configuration: config)
    }
            
    func getOneDayWeatherDataForPoi(poi : String) -> WeatherDataOneDay? {
        let weatherData = realm?.object(ofType: WeatherDataOneDayCached.self, forPrimaryKey: poi)
        if let weatherData = weatherData {
            let result = WeatherDataOneDay()
            result.temperature = weatherData.temperature ?? 0
            result.temperatureDescription = weatherData.temperatureDescription ?? ""
            result.condition = weatherData.condition ?? 0
            result.city = weatherData.city ?? ""
            result.weatherIconName = weatherData.weatherIconName ?? ""
            result.sunset = weatherData.sunset ?? 0.0
            result.sunrise = weatherData.sunrise ?? 0.0
            result.humidity = weatherData.humidity ?? 0
            result.windSpeed = weatherData.windSpeed ?? 0.0
            result.date = weatherData.date ?? 0.0
            result.feelsLike = weatherData.feelsLike ?? 0
            result.clouds = weatherData.clouds ?? 0
            result.lon = weatherData.lon ?? 0.0
            result.lat = weatherData.lat ?? 0.0

            return result
        } else {
            return nil
        }
    }
    
    func addOneDayWeatherDataForPoi(poi : String, weatherData: WeatherDataOneDay) {
        let cachedWeatherData = WeatherDataOneDayCached()
        cachedWeatherData.poi = poi
        
        cachedWeatherData.temperature = weatherData.temperature
        cachedWeatherData.temperatureDescription = weatherData.temperatureDescription
        cachedWeatherData.condition = weatherData.condition
        cachedWeatherData.city = weatherData.city
        cachedWeatherData.weatherIconName = weatherData.weatherIconName
        cachedWeatherData.sunset = weatherData.sunset
        cachedWeatherData.sunrise = weatherData.sunrise
        cachedWeatherData.humidity = weatherData.humidity
        cachedWeatherData.windSpeed = weatherData.windSpeed
        cachedWeatherData.date = weatherData.date
        cachedWeatherData.feelsLike = weatherData.feelsLike
        cachedWeatherData.clouds = weatherData.clouds
        cachedWeatherData.lon = weatherData.lon
        cachedWeatherData.lat = weatherData.lat
        
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
        return realm?.object(ofType: WeatherDataOneDayCached.self, forPrimaryKey: poi) != nil
    }
}

class WeatherDataOneDayDB {
    private let dbDataProvider : WeatherDataOneDayDbProvider = WeatherDataOneDayDbProvider()
    
    static var shared: WeatherDataOneDayDB = {
        let instance = WeatherDataOneDayDB()
        return instance
    }()

    private init() {}
    
    func getOneDayWeatherDataForPoi(poi : String) -> WeatherDataOneDay? {
        return dbDataProvider.getOneDayWeatherDataForPoi(poi: poi)
    }
    
    func addOneDayWeatherDataForPoi(poi : String, weatherData: WeatherDataOneDay) {
        return dbDataProvider.addOneDayWeatherDataForPoi(poi: poi, weatherData: weatherData)
    }
}
