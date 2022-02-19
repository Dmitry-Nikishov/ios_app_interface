//
//  WeatherDataProvider.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 10.02.2022.
//

import Foundation

class WeatherDataProvider {
    private let monthlyDb = WeatherDataMonthlyDB.shared
    private let hourlyDb = WeatherDataHourlyDB.shared
    private let oneDayDb = WeatherDataOneDayDB.shared
    private let apiClient = WeatherClient.shared
    private let geoPointsDb = GeoPointsDB.shared
    
    static var shared: WeatherDataProvider = {
        let instance = WeatherDataProvider()
        return instance
    }()

    private init() {}

    func getMonthlyData(poi : String,
                        dataHandler : @escaping MonthlyWeatherDataHandler)
    {
        if let weatherData = monthlyDb.getMonthlyWeatherDataForPoi(poi: poi) {
            dataHandler(weatherData)
        } else {
            if let geoPoint = geoPointsDb.getGeoPoint(id: poi) {
                let latitudeString = "\(geoPoint.latitude)"
                let longitudeString = "\(geoPoint.longitude)"

                apiClient.getMonthlyForecast(latitude: latitudeString,
                                            longitude: longitudeString) { [weak self] weatherData in
                    DispatchQueue.main.async { [weak self] in
                        if let data = weatherData {
                            self?.monthlyDb.addMonthlyWeatherDataForPoi(poi: poi, weatherData: data)
                        }
                    }

                    dataHandler(weatherData)
                }
            } else {
                dataHandler(nil)
            }
        }
    }
    
    func getOneDayData(poi : String,
                       dataHandler : @escaping OneDayWeatherDataHandler)
    {
        if let weatherData = oneDayDb.getOneDayWeatherDataForPoi(poi: poi) {
            dataHandler(weatherData)
        } else {
            if let geoPoint = geoPointsDb.getGeoPoint(id: poi) {
                let latitudeString = "\(geoPoint.latitude)"
                let longitudeString = "\(geoPoint.longitude)"

                apiClient.getOneDayForecast(latitude: latitudeString,
                                            longitude: longitudeString) { [weak self] weatherData in
                    DispatchQueue.main.async { [weak self] in
                        if let data = weatherData {
                            self?.oneDayDb.addOneDayWeatherDataForPoi(poi: poi, weatherData: data)
                        }
                    }

                    dataHandler(weatherData)
                }
            } else {
                dataHandler(nil)
            }
        }
    }
    
    func getHourlyData(poi : String,
                       dataHandler : @escaping HourlyWeatherDataHandler)
    {
        if let weatherData = hourlyDb.getHourlyWeatherDataForPoi(poi: poi) {
            dataHandler(weatherData)
        } else {
            if let geoPoint = geoPointsDb.getGeoPoint(id: poi) {
                let latitudeString = "\(geoPoint.latitude)"
                let longitudeString = "\(geoPoint.longitude)"

                apiClient.getHourlyForecast(latitude: latitudeString,
                                            longitude: longitudeString) { [weak self] weatherData in
                    DispatchQueue.main.async { [weak self] in
                        if let data = weatherData {
                            self?.hourlyDb.addHourlyWeatherDataForPoi(poi: poi, weatherData: data)
                        }
                    }

                    dataHandler(weatherData)
                }
            } else {
                dataHandler(nil)
            }
        }
    }
}
