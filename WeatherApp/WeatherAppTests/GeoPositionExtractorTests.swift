//
//  GeoPositionExtractorTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 29.01.2022.
//

import XCTest
@testable import WeatherApp

class GeoPositionExtractorTests: XCTestCase {
    func testScenario0() throws {
        let result = GeoPositionExtractor.extract(from: "37.622513 55.75322")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.latitude, Float(37.622513))
        XCTAssertEqual(result?.longitude, Float(55.75322))
    }
    
    func testScenario1() throws {
        XCTAssertNil(GeoPositionExtractor.extract(from: "37.622513"))
    }

    func testScenario2() throws {
        XCTAssertNil(GeoPositionExtractor.extract(from: "37.622513 55.75322rt"))
    }
}
