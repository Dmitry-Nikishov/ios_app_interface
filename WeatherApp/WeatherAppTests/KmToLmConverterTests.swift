//
//  KmToLmConverterTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 14.02.2022.
//

import XCTest
@testable import WeatherApp

class KmToLmConverterTests: XCTestCase {
    func testKmToMlConversion() throws {
        XCTAssertEqual(KmToMlConverter.toMl(km: 1), 0.6214)
    }

    func testMlToKmConversion() throws {
        XCTAssertEqual(KmToMlConverter.toKm(ml: 1), 1.6093)
    }
}
