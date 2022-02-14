//
//  WeatherUIData.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 05.02.2022.
//

import Foundation
import SwiftUI

class UiDayItem {
    var calendarDate : String = ""
}

class UiMonthlyDays {
    var items : [UiDayItem] = []
}

class UiMonthlySunAndMoonDetails {
    var moonRise : String = ""
    var moonSet : String = ""
    var sunRise : String = ""
    var sunSet : String = ""
    var sunDuration : String = ""
    var moonDuration : String = ""
}

class UiMonthlyAirQuality {
    var value : String = ""
    var estimation : String = ""
}

class UiMonthlyDayNightDetails {
    var temperature : String = ""
    var feelsLikeTemperature : String = ""
    var windSpeed : String = ""
    var humidity : String = ""
    var cloudy : String = ""
    var ufIndex : String = ""
}

class UiMonthlyData {
    var calendarDays : UiMonthlyDays = UiMonthlyDays()
    var dayDetails : [UiMonthlyDayNightDetails] = []
    var nightDetails : [UiMonthlyDayNightDetails] = []
    var airQuality : [UiMonthlyAirQuality] = []
    var moonAndSunDetails : [UiMonthlySunAndMoonDetails] = []
}

class UiPerHourChartDataItem {
    var temperature : Double = 0
    var humidity : Double = 0
    var dayTime : String = ""
}

class UiPerHourChartData {
    var items : [UiPerHourChartDataItem] = []
}

class UiPerHourDetailsItem {
    var calendarDate : String = ""
    var dayTime : String = ""
    var temperature : String = ""
    var temperatureDescription : String = ""
    var windDescription : String = ""
    var humidity : String = ""
    var cloudy : String = ""
}

class UiPerHourDetails {
    var items : [UiPerHourDetailsItem] = []
}

class UiPerHourDetailsData {
    var details : UiPerHourDetails = UiPerHourDetails()
    var chartData : UiPerHourChartData = UiPerHourChartData()
}

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

class AirQualityEstimator {
    public static func estimate(_ value : Int) -> String
    {
        if value < 20 {
            return "Плохо"
        }
        
        if value < 40 {
            return "Неудовлетворительно"
        }

        if value < 60 {
            return "Удовлетворительно"
        }

        if value < 80 {
            return "Хорошо"
        }

        return "Отлично"
    }
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
    
    private static func weatherHourlyItemToChartRepresentation(dataItem : WeatherDataHourDetails) -> UiPerHourChartDataItem
    {
        let result = UiPerHourChartDataItem()
        result.temperature = Double(dataItem.temperature)
        result.humidity = Double(dataItem.humidity)
        let currentDate = NSDate(timeIntervalSince1970: dataItem.date)
        result.dayTime = UIDateDateFormatter.convertDateToGraphRepresentation(currentDate as Date)
        return result
    }
    
    private static func weatherHourlyItemToViewRepresentation(dataItem : WeatherDataHourDetails) -> UiPerHourDetailsItem
    {
        let result = UiPerHourDetailsItem()
        let currentDate = NSDate(timeIntervalSince1970: dataItem.date)
        result.dayTime = UIDateDateFormatter.formatTimeOfDay(date: currentDate as Date)
        result.humidity = "\(dataItem.humidity)%"
        result.temperature = "\(dataItem.temperature)°"
        result.temperatureDescription = "Преимущественно \(dataItem.temperature)°. Ощущается как \(dataItem.feelsLike)°"
        result.calendarDate = UIDateDateFormatter.formatForCalendarDate(date: currentDate as Date)
        result.cloudy = "\(dataItem.clouds)"
        result.windDescription = "\(dataItem.windSpeed)"
        
        return result
    }
    
    public static func convertHourlyDataToHourlyControllerFormat(dataForUi : WeatherDataHourly?) -> UiPerHourDetailsData
    {
        let result = UiPerHourDetailsData()
        
        if let data = dataForUi {
            let chartData = UiPerHourChartData()
            chartData.items = data.hourly.enumerated().compactMap { index, element in index % 3 == 0 ? weatherHourlyItemToChartRepresentation(dataItem: element) : nil }
            result.chartData = chartData

            let details = UiPerHourDetails()
            details.items = data.hourly.enumerated().compactMap { index, element in index % 3 == 0 ? weatherHourlyItemToViewRepresentation(dataItem: element) : nil }
            result.details = details
        }
        
        return result
    }
    
    public static func convertMonthlyDataToUiRepresentation(weatherData : WeatherDataMonthly) -> UiMonthlyData
    {
        let result = UiMonthlyData()
        result.calendarDays.items = weatherData.days.compactMap { item in
            let result = UiDayItem()
            
            let currentDate = NSDate(timeIntervalSince1970: item.date)
            result.calendarDate = UIDateDateFormatter.formatForCalendarDateWithDay(date: currentDate as Date)
            
            return result
        }
        
        result.dayDetails = weatherData.days.compactMap { item in
            let result = UiMonthlyDayNightDetails()
            result.cloudy = "\(item.clouds)"
            result.humidity = "\(item.humidity)%"
            result.windSpeed = "\(item.windSpeed)"
            result.temperature = "\(item.temperatureDay)°"
            result.feelsLikeTemperature = "\(item.feelsLikeDay)°"
            result.ufIndex = "\(Int.random(in: 0...10))"
            return result
        }

        result.nightDetails = weatherData.days.compactMap { item in
            let result = UiMonthlyDayNightDetails()
            result.cloudy = "\(item.clouds)"
            result.humidity = "\(item.humidity)%"
            result.windSpeed = "\(item.windSpeed)"
            result.temperature = "\(item.temperatureNight)°"
            result.feelsLikeTemperature = "\(item.feelsLikeNight)°"
            result.ufIndex = "\(Int.random(in: 0...10))"
            return result
        }

        result.moonAndSunDetails = weatherData.days.compactMap { item in
            let result = UiMonthlySunAndMoonDetails()
            
            let moonSetDate = NSDate(timeIntervalSince1970: item.moonset) as Date
            let moonRiseDate = NSDate(timeIntervalSince1970: item.moonrise) as Date
            let moonDuration = moonSetDate.distance(to: moonRiseDate)
            
            result.moonSet = UIDateDateFormatter.formatTimeOfDay(date: moonSetDate)
            result.moonRise = UIDateDateFormatter.formatTimeOfDay(date: moonRiseDate)
            result.moonDuration = UIDateDateFormatter.formatTimeOfDay(date: NSDate(timeIntervalSinceReferenceDate: moonDuration) as Date)
            
            let sunSetDate = NSDate(timeIntervalSince1970: item.sunset) as Date
            let sunRiseDate = NSDate(timeIntervalSince1970: item.moonset) as Date
            let sunDuration = sunSetDate.distance(to: sunRiseDate)
            
            result.sunSet = UIDateDateFormatter.formatTimeOfDay(date: sunSetDate)
            result.sunRise = UIDateDateFormatter.formatTimeOfDay(date: sunRiseDate)
            result.sunDuration = UIDateDateFormatter.formatTimeOfDay(date: NSDate(timeIntervalSinceReferenceDate: sunDuration) as Date)

            return result
        }

        result.airQuality = weatherData.days.compactMap { item in
            let result = UiMonthlyAirQuality()
            let quality = Int.random(in: 0...100)
            result.value = "\(quality)"
            result.estimation = AirQualityEstimator.estimate(quality)
            return result
        }

        return result
    }
}

