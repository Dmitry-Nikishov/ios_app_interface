//
//  GeocodingTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 29.01.2022.
//

import XCTest
@testable import WeatherApp

class GeocodingTests: XCTestCase {
    
    func testGeocodingInfoRetrieving() throws {
        let geoService = YandexGeocoding.shared
        let geoInfo = geoService.getGeoCode(geocode: "Москва")
        XCTAssertNotNil(geoInfo)
        XCTAssertEqual(geoInfo?.latitude, Float(37.622513))
        XCTAssertEqual(geoInfo?.longitude, Float(55.75322))
    }
}
