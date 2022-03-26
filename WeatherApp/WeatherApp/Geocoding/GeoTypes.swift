//
//  GeoTypes.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 28.01.2022.
//

import Foundation
import CoreLocation

typealias LocationUpdateHandler = (CLLocation) -> Void

struct GeoPosition {
    let latitude : Float
    let longitude : Float
}
