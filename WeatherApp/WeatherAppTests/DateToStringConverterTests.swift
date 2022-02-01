//
//  DateToStringConverterTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 27.01.2022.
//

import XCTest
@testable import WeatherApp

class DateToStringConverterTests: XCTestCase {
    func testDateToStringConversion() throws {
        let testDate = Date(timeIntervalSinceReferenceDate: 0)
        let testDateString = DateToStringConverter.convertDateToGraphRepresentation(testDate)
        let expectedTestDateString = "03:00"
        XCTAssertEqual(testDateString, expectedTestDateString)
    }
}
