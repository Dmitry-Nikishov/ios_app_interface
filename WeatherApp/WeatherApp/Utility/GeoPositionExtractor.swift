//
//  GeoPositionExtractor.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 29.01.2022.
//

import Foundation

class GeoPositionExtractor {
    static func extract(from : String) -> GeoPosition? {
        let components = from.components(separatedBy: [" "]).compactMap { str in Float(str) }

        if components.count != 2 {
            return nil
        } else {
            return GeoPosition(latitude: components[1], longitude: components[0])
        }        
    }
}
