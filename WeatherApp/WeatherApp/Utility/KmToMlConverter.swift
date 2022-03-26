//
//  KmToMlConverter.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 14.02.2022.
//

import Foundation

class KmToMlConverter {
    public static func toMl(km : Float) -> Float
    {
        return 0.6214*km
    }
    
    public static func toKm(ml : Float) -> Float
    {
        return 1.6093*ml
    }
}
