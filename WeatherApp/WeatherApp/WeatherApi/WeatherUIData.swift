//
//  WeatherUIData.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 05.02.2022.
//

import Foundation
import SwiftUI

class UiWeatherDataOneDay {
    var temperature : String = ""
    var feelsLikeTemperature : String = ""
    var description : String = ""
    var sunsetTime : String = ""
    var sunriseTime : String = ""
    var humidity : String = ""
    var windSpeed : String = ""
    var clouds : String = ""
    var dayTimePeriod : String = ""
}

class UiPerHourCollectionDataItem {
    var temperature : String = ""
    var dayTime : String = ""
}

class UiPerDayCollectionDataItem {
    var calendarDate : String = ""
    var humidity : String = ""
    var description : String = ""
    var forecastTemperature : String = ""
}

extension StringProtocol {
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

class WeatherDataToUiRepresentationConverter {
    private static func weatherHourlyItemToUiRepresentation(dataItem : WeatherDataHourDetails) -> UiPerHourCollectionDataItem {
        let result = UiPerHourCollectionDataItem()
        
        let currentDate = NSDate(timeIntervalSince1970: dataItem.date)
        result.dayTime = UIDateDateFormatter.formatTimeOfDay(date: currentDate as Date)
        result.temperature = "\(dataItem.temperature)°"
        
        return result
    }
    
    public static func convertPerHourDataToUiPerHourCollectionData(data : WeatherDataHourly) -> [UiPerHourCollectionDataItem] {
        return data.hourly.enumerated().compactMap { index, element in index % 3 == 0 ? weatherHourlyItemToUiRepresentation(dataItem: element) : nil }
    }
    
    public static func convertMonthlyDataToUiCollectionData(data : WeatherDataMonthly) -> [UiPerDayCollectionDataItem] {
        return data.days.map { dataItem in
            let result = UiPerDayCollectionDataItem()
            let currentDate = NSDate(timeIntervalSince1970: dataItem.date)
            result.calendarDate = UIDateDateFormatter.formatForCalendarDate(date: currentDate as Date)
            result.humidity = "\(dataItem.humidity) %"
            result.description = "\(dataItem.weatherDescription)"
            result.forecastTemperature = "\(dataItem.temperatureNight)°-\(dataItem.temperatureDay)°"
            return result
        }
    }
    
    public static func convertOneDayData(data : WeatherDataOneDay) -> UiWeatherDataOneDay
    {
        let result = UiWeatherDataOneDay()
        
        result.temperature = "\(data.temperature)°"
        result.description = data.temperatureDescription.firstCapitalized
        
        let sunsetDate = NSDate(timeIntervalSince1970: data.sunset)
        result.sunsetTime = UIDateDateFormatter.formatTimeOfDay(date: sunsetDate as Date)

        let sunriseDate = NSDate(timeIntervalSince1970: data.sunrise)
        result.sunriseTime = UIDateDateFormatter.formatTimeOfDay(date: sunriseDate as Date)
        
        result.humidity = "\(data.humidity) %"
        result.windSpeed = "\(Int(data.windSpeed.rounded(.up))) м/с"
        
        result.clouds = "\(data.clouds)"

        let date = NSDate(timeIntervalSince1970: data.date)
        result.dayTimePeriod = UIDateDateFormatter.formatDayTimePeriod(date: date as Date)
        
        result.feelsLikeTemperature = "\(data.feelsLike)° / \(data.temperature)°"
        
        return result
    }
}

