//
//  AppConstants.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 12.01.2022.
//

import UIKit

enum AppCommonStrings {
    static let appName : String = "Weather App"
}

enum UserDefaultsSettingsKeys {
    static let temperatureSettings : String = "temperatureInCelsiusOrFahrenheit"
    static let windSpeedSettings : String = "windSpeedInMiOrKm"
    static let timeFormatSettings : String = "12HourOr24HourFormat"
    static let notificationSettings : String = "notificationsAreOnOrOff"
}
