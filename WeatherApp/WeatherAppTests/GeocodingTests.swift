//
//  GeocodingTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 29.01.2022.
//

import XCTest
@testable import WeatherApp

class GeocodingTests: XCTestCase {
    
    func testGeocodingMoscowInfoRetrieving() throws {
        let geoService = YandexGeocoding.shared
        let geoInfo = geoService.getGeoCode(geocode: "Москва")
        XCTAssertNotNil(geoInfo)
        XCTAssertEqual(geoInfo?.latitude, Float(55.75322))
        XCTAssertEqual(geoInfo?.longitude, Float(37.622513))
    }
    
    func testGeocodingMunichInfoRetrieving() throws {
        let geoService = YandexGeocoding.shared
        let geoInfo = geoService.getGeoCode(geocode: "Мюнхен")
        XCTAssertNotNil(geoInfo)
        XCTAssertEqual(geoInfo?.latitude, Float(48.13719))
        XCTAssertEqual(geoInfo?.longitude, Float(11.575691))
    }
}
