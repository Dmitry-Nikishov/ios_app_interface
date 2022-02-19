//
//  WeatherApiTests.swift
//  WeatherAppTests
//
//  Created by Дмитрий Никишов on 03.02.2022.
//

import XCTest
@testable import WeatherApp

class WeatherApiTests: XCTestCase {

    func testOneDayForecastRetrieving() throws {
        var result : WeatherDataOneDay? = nil
        
        WeatherClient.shared.getOneDayForecast(latitude: "55.75322",
                                               longitude: "37.622513") { weatherData in
            result = weatherData
        }

        sleep(1)
        
        XCTAssertNotNil(result)
    }
    
    func testHourlyForecastReceiving() throws {
        var result : WeatherDataHourly? = nil
        
        WeatherClient.shared.getHourlyForecast(latitude: "55.75322",
                                               longitude: "37.622513") { weatherData in
            result = weatherData
        }
        
        sleep(1)
        
        XCTAssertNotNil(result)
    }
    
    func testMonthlyForecastReceiving() throws {
        var result : WeatherDataMonthly? = nil
        
        WeatherClient.shared.getMonthlyForecast(latitude: "55.75322",
                                                longitude: "37.622513") { weatherData in
            result = weatherData
        }
        
        sleep(1)
        
        XCTAssertNotNil(result)
    }
}
