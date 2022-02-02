//
//  WeatherApiTypes.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 03.02.2022.
//

import Foundation

typealias OneDayWeatherDataHandler = (WeatherDataOneDay?) -> ()
typealias HourlyWeatherDataHandler = (WeatherDataHourly?) -> ()
typealias MonthlyWeatherDataHandler = (WeatherDataMonthly?) -> ()
