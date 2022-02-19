//
//  YandexGeocoderPrimitives.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 04.02.2022.
//

import Foundation

public final class YandexGeocoderResponse: Codable {
    let response: GeoObjectResponse
}

struct GeoObjectResponse: Codable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

struct GeoObjectCollection: Codable {
    let featureMember: [GeoObjectFeatureMember]
}

struct GeoObjectFeatureMember: Codable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

struct GeoObject: Codable {
    let city, country: String
    let point: GeoObjectPoint

    enum CodingKeys: String, CodingKey {
        case city = "name"
        case country = "description"
        case point = "Point"
    }    
}

struct GeoObjectPoint: Codable {
    let pos: String
}
