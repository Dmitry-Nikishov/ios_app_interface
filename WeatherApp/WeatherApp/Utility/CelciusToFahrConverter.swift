//
//  CelciusToFahrConverter.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 14.02.2022.
//

import Foundation

class CelciusToFahrConverter
{
    public static func toCelcius(fh : Float) -> Float
    {
        return (fh - 32)/1.8
    }
    
    public static func toFahr(cel : Float) -> Float
    {
        return cel*1.8 + 32
    }
}
