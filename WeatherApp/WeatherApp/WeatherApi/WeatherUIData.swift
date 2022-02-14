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
    var description : String = ""
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
        let isFormat12Hour = UserDefaults.standard.bool(forKey: UserDefaultsSettingsKeys.timeFormatSettings)
        let isTemperatureInFah = UserDefaults.standard.bool(forKey: UserDefaultsSettingsKeys.temperatureSettings) == false

        let currentDate = NSDate(timeIntervalSince1970: dataItem.date)
        
        if isFormat12Hour == true {
            result.dayTime = UIDateDateFormatter.formatTimeOfDay12Format(date: currentDate as Date)
        } else {
            result.dayTime = UIDateDateFormatter.formatTimeOfDay(date: currentDate as Date)
        }
        
        if isTemperatureInFah {
            result.temperature = "\(CelciusToFahrConverter.toFahr(cel: Float(dataItem.temperature)))°"
        } else {
            result.temperature = "\(dataItem.temperature)°"
        }
        
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
        let userDefaults = UserDefaults.standard
        let isWindSpeedInMiles = userDefaults.bool(forKey: UserDefaultsSettingsKeys.windSpeedSettings)
        let isFormat12Hour = userDefaults.bool(forKey: UserDefaultsSettingsKeys.timeFormatSettings)
        let isTemperatureInFah = userDefaults.bool(forKey: UserDefaultsSettingsKeys.temperatureSettings) == false

        result.description = data.temperatureDescription.firstCapitalized
        
        let sunsetDate = NSDate(timeIntervalSince1970: data.sunset)
        result.sunsetTime = UIDateDateFormatter.formatTimeOfDay(date: sunsetDate as Date)

        let sunriseDate = NSDate(timeIntervalSince1970: data.sunrise)
        result.sunriseTime = UIDateDateFormatter.formatTimeOfDay(date: sunriseDate as Date)
        
        result.humidity = "\(data.humidity) %"
        if isWindSpeedInMiles {
            result.windSpeed = "\(KmToMlConverter.toMl(km: Float(data.windSpeed.rounded(.up)))) мили/ч"
        } else {
            result.windSpeed = "\(Int(data.windSpeed.rounded(.up))) м/с"
        }
        
        result.clouds = "\(data.clouds)"

        let date = NSDate(timeIntervalSince1970: data.date)
        if isFormat12Hour == true {
            result.dayTimePeriod = UIDateDateFormatter.formatDayTimePeriod12Format(date: date as Date)
        } else {
            result.dayTimePeriod = UIDateDateFormatter.formatDayTimePeriod(date: date as Date)
        }
        
        if isTemperatureInFah {
            let temperatureInFh = CelciusToFahrConverter.toFahr(cel: Float(data.temperature))
            let feelsLikeTemperatureInFh = CelciusToFahrConverter.toFahr(cel: Float(data.feelsLike))

            result.feelsLikeTemperature = "\(feelsLikeTemperatureInFh)°F / \(temperatureInFh)°F"
            result.temperature = "\(temperatureInFh)°F"
        } else {
            result.feelsLikeTemperature = "\(data.feelsLike)° / \(data.temperature)°"
            result.temperature = "\(data.temperature)°"
        }
        
        
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
        let userDefaults = UserDefaults.standard
        let isWindSpeedInMiles = userDefaults.bool(forKey: UserDefaultsSettingsKeys.windSpeedSettings)
        let isFormat12Hour = userDefaults.bool(forKey: UserDefaultsSettingsKeys.timeFormatSettings)
        let isTemperatureInFah = userDefaults.bool(forKey: UserDefaultsSettingsKeys.temperatureSettings) == false

        let currentDate = NSDate(timeIntervalSince1970: dataItem.date)
        if isFormat12Hour == true {
            result.dayTime = UIDateDateFormatter.formatTimeOfDay12Format(date: currentDate as Date)
        } else {
            result.dayTime = UIDateDateFormatter.formatTimeOfDay(date: currentDate as Date)
        }
        
        result.humidity = "\(dataItem.humidity)%"
        
        if isTemperatureInFah {
            let temperatureInFh = CelciusToFahrConverter.toFahr(cel: Float(dataItem.temperature))
            let feelsLikeTemperatureInFh = CelciusToFahrConverter.toFahr(cel: Float(dataItem.feelsLike))
            
            result.temperature = "\(temperatureInFh)°"
            result.temperatureDescription = "Преимущественно \(temperatureInFh)°. Ощущается как \(feelsLikeTemperatureInFh)°"
        } else {
            result.temperature = "\(dataItem.temperature)°"
            result.temperatureDescription = "Преимущественно \(dataItem.temperature)°. Ощущается как \(dataItem.feelsLike)°"
        }
        
        result.calendarDate = UIDateDateFormatter.formatForCalendarDate(date: currentDate as Date)
        result.cloudy = "\(dataItem.clouds)"
        if isWindSpeedInMiles {
            result.windDescription = "\(KmToMlConverter.toMl(km: dataItem.windSpeed))"
        } else {
            result.windDescription = "\(dataItem.windSpeed)"
        }
        
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
        let userDefaults = UserDefaults.standard
        
        let isFormat12Hour = userDefaults.bool(forKey: UserDefaultsSettingsKeys.timeFormatSettings)
        let isWindSpeedInMiles = userDefaults.bool(forKey: UserDefaultsSettingsKeys.windSpeedSettings)
        let isTemperatureInFah = userDefaults.bool(forKey: UserDefaultsSettingsKeys.temperatureSettings)
        
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
            if isWindSpeedInMiles {
                result.windSpeed = "\(KmToMlConverter.toMl(km: item.windSpeed))"
            } else {
                result.windSpeed = "\(item.windSpeed)"
            }
            
            if isTemperatureInFah == true {
                result.temperature = "\(CelciusToFahrConverter.toFahr(cel: Float(item.temperatureDay)))°F"
                
                result.feelsLikeTemperature = "\(CelciusToFahrConverter.toFahr(cel: Float(item.feelsLikeDay)))°F"
            } else {
                result.temperature = "\(item.temperatureDay)°"
                result.feelsLikeTemperature = "\(item.feelsLikeDay)°"
            }
            result.ufIndex = "\(item.uvi)"
            result.description = item.weatherDescription
            return result
        }

        result.nightDetails = weatherData.days.compactMap { item in
            let result = UiMonthlyDayNightDetails()
            result.cloudy = "\(item.clouds)"
            result.humidity = "\(item.humidity)%"
            if isWindSpeedInMiles {
                result.windSpeed = "\(KmToMlConverter.toMl(km: item.windSpeed))"
            } else {
                result.windSpeed = "\(item.windSpeed)"
            }

            if isTemperatureInFah == true {
                result.temperature = "\(CelciusToFahrConverter.toFahr(cel: Float(item.temperatureDay)))°F"
                
                result.feelsLikeTemperature = "\(CelciusToFahrConverter.toFahr(cel: Float(item.feelsLikeDay)))°F"
            } else {
                result.temperature = "\(item.temperatureNight)°"
                result.feelsLikeTemperature = "\(item.feelsLikeNight)°"
            }
            result.ufIndex = "\(item.uvi)"
            result.description = item.weatherDescription
            return result
        }

        result.moonAndSunDetails = weatherData.days.compactMap { item in
            let result = UiMonthlySunAndMoonDetails()
            
            let moonSetDate = NSDate(timeIntervalSince1970: item.moonset) as Date
            let moonRiseDate = NSDate(timeIntervalSince1970: item.moonrise) as Date
            let moonDuration = moonSetDate.distance(to: moonRiseDate)

            let sunSetDate = NSDate(timeIntervalSince1970: item.sunset) as Date
            let sunRiseDate = NSDate(timeIntervalSince1970: item.sunrise) as Date
            let sunDuration = sunSetDate.distance(to: sunRiseDate)

            if isFormat12Hour == true {
                result.moonSet = UIDateDateFormatter.formatTimeOfDay12Format(date: moonSetDate)
                result.moonRise = UIDateDateFormatter.formatTimeOfDay12Format(date: moonRiseDate)
                result.moonDuration = UIDateDateFormatter.formatTimeOfDay12Format(date: NSDate(timeIntervalSinceReferenceDate: moonDuration) as Date)

                result.sunSet = UIDateDateFormatter.formatTimeOfDay12Format(date: sunSetDate)
                result.sunRise = UIDateDateFormatter.formatTimeOfDay12Format(date: sunRiseDate)
                result.sunDuration = UIDateDateFormatter.formatTimeOfDay12Format(date: NSDate(timeIntervalSinceReferenceDate: sunDuration) as Date)
            } else {
                result.moonSet = UIDateDateFormatter.formatTimeOfDay(date: moonSetDate)
                result.moonRise = UIDateDateFormatter.formatTimeOfDay(date: moonRiseDate)
                result.moonDuration = UIDateDateFormatter.formatTimeOfDay(date: NSDate(timeIntervalSinceReferenceDate: moonDuration) as Date)

                result.sunSet = UIDateDateFormatter.formatTimeOfDay(date: sunSetDate)
                result.sunRise = UIDateDateFormatter.formatTimeOfDay(date: sunRiseDate)
                result.sunDuration = UIDateDateFormatter.formatTimeOfDay(date: NSDate(timeIntervalSinceReferenceDate: sunDuration) as Date)
            }

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

