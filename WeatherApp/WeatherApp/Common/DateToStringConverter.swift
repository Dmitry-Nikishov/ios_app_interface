//
//  DateToStringConverter.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 11.01.2022.
//

import Foundation

class DateToStringConverter {
    public static func convertDateToGraphRepresentation(_ date : Date,
                                                        locale : Locale = Locale(identifier: "ru_RU"),
                                                        dateFormat : String = "HH:00") -> String
    {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = locale
        dayTimePeriodFormatter.dateFormat = dateFormat
        return dayTimePeriodFormatter.string(from: date)
    }
}
