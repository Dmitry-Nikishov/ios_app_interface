//
//  CelciusToFahrConverterTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 14.02.2022.
//

import XCTest
@testable import WeatherApp

class CelciusToFahrConverterTests: XCTestCase {
    func testCelciusToFahrConverter() throws {
        XCTAssertEqual(CelciusToFahrConverter.toFahr(cel: -10), 14)
    }

    func testFahrToCenciusConverter() throws {
        XCTAssertEqual(CelciusToFahrConverter.toCelcius(fh: 32), 0)
    }
}
