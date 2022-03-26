import Foundation
import RealmSwift

class WeatherDataOneDayCached: Object {
    @objc dynamic var poi: String = ""
    
    @objc dynamic var temperature: Int = 0
    @objc dynamic var temperatureDescription: String = ""
    @objc dynamic var condition: Int = 0
    @objc dynamic var city: String = ""
    @objc dynamic var weatherIconName: String = ""
    @objc dynamic var sunset: Double = 0
    @objc dynamic var sunrise: Double = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var windSpeed: Float = 0
    @objc dynamic var date: Double = 0
    @objc dynamic var feelsLike: Int = 0
    @objc dynamic var clouds: Int = 0
    @objc dynamic var lon: Float = 0
    @objc dynamic var lat: Float = 0

    override static func primaryKey() -> String? {
        return "poi"
    }
    
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

class WeatherDataOneDayDbProvider {
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(AppCommonStrings.appRealmDbName)
        realm = try? Realm(configuration: config)
    }
            
    func getOneDayWeatherDataForPoi(poi : String) -> WeatherDataOneDay? {
        let weatherData = realm?.object(ofType: WeatherDataOneDayCached.self, forPrimaryKey: poi)
        if let weatherData = weatherData {
            let result = WeatherDataOneDay()
            result.temperature = weatherData.temperature
            result.temperatureDescription = weatherData.temperatureDescription
            result.condition = weatherData.condition
            result.city = weatherData.city
            result.weatherIconName = weatherData.weatherIconName
            result.sunset = weatherData.sunset
            result.sunrise = weatherData.sunrise
            result.humidity = weatherData.humidity
            result.windSpeed = weatherData.windSpeed
            result.date = weatherData.date
            result.feelsLike = weatherData.feelsLike
            result.clouds = weatherData.clouds
            result.lon = weatherData.lon
            result.lat = weatherData.lat
            
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
                realm?.add(cachedWeatherData, update: .all)
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
