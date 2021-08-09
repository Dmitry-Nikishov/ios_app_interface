//
//  DateToFromStringConverter.swift
//  ght
//
//  Created by Дмитрий Никишов on 01.08.2021.
//

import Foundation

class DateToFromStringConverter {
    static func fromString(dateAsString : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.date(from: dateAsString)
    }
    
    static func toString(date : Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func toStringWithCalendarData(date : Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        return dateFormatter.string(from: date)
    }

}
