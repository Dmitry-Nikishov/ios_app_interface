//
//  SimDateRangeProvider.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 11.01.2022.
//

import Foundation

class SimDateRangeProvider {
    public static func getDayRangeByHourInterval(_ by : Int) -> [String]
    {
        var currentDate = Date()
        var arrayOfDates : [String] = []

        let timeIntervalIncrementStep : TimeInterval = 60*60*Double(by)

        for _ in stride(from: 0, to: 24, by: by) {
            arrayOfDates.append(DateToStringConverter.convertDateToGraphRepresentation(currentDate))
            currentDate.addTimeInterval(timeIntervalIncrementStep)
        }

        return arrayOfDates
    }
    
    public static func getHumidityData(_ count : Int) -> [Double]
    {
        var ret : [Double] = []
        for _ in 0..<count {
            ret.append(Double(Int.random(in: 0...100)))
        }
        
        return ret
    }
    
    public static func getTemperatureData(_ count : Int) -> [Double]
    {
        var ret : [Double] = []
        for _ in 0..<count {
            ret.append(Double(Int.random(in: -30...30)))
        }
        
        return ret
    }

}
