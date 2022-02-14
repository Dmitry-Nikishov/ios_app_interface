//
//  UiDateTimeFormaterTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 05.02.2022.
//

import XCTest
@testable import WeatherApp

class UiDateTimeFormatterTests: XCTestCase {
    func testDateToStringConversion() throws {
        let testDate = Date(timeIntervalSinceReferenceDate: 0)
        let testDateString = UIDateDateFormatter.convertDateToGraphRepresentation(testDate)
        let expectedTestDateString = "03:00"
        XCTAssertEqual(testDateString, expectedTestDateString)
    }

    func testTimeOfDayFormatter() throws {
        let testDate = NSDate(timeIntervalSince1970: 0)
        let testDateString = UIDateDateFormatter.formatTimeOfDay(date: testDate as Date)
        let expectedTestDateString = "03:00"
        XCTAssertEqual(testDateString, expectedTestDateString)
    }

    func testDayTimePeriodFormatter() throws {
        let testDate = NSDate(timeIntervalSince1970: 0)
        let testDateString = UIDateDateFormatter.formatDayTimePeriod(date: testDate as Date)
        let expectedTestDateString = "03:00, Чт 01 января"
        XCTAssertEqual(testDateString, expectedTestDateString)
    }
    
    func testFormatForCalendarDate() throws {
        let testDate = NSDate(timeIntervalSince1970: 0)
        let testDateString = UIDateDateFormatter.formatForCalendarDate(date: testDate as Date)
        let expectedTestDateString = "01/01"
        XCTAssertEqual(testDateString, expectedTestDateString)
    }
    
    func testFormatForCalendarDateWithDay() throws {
        let testDate = NSDate(timeIntervalSince1970: 0)
        let testDateString = UIDateDateFormatter.formatForCalendarDateWithDay(date: testDate as Date)
        let expectedTestDateString = "01/01 Чт"
        XCTAssertEqual(testDateString, expectedTestDateString)
    }
}
