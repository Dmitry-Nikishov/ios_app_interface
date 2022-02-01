// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let geoInfo = try? newJSONDecoder().decode(GeoInfo.self, from: jsonData)

import Foundation

// MARK: - GeoInfo
struct GeoInfo: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
    let featureMember: [FeatureMember]
    let metaDataProperty: GeoObjectCollectionMetaDataProperty
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let metaDataProperty: GeoObjectMetaDataProperty
    let boundedBy: BoundedBy
    let geoObjectDescription, name: String
    let point: Point

    enum CodingKeys: String, CodingKey {
        case metaDataProperty, boundedBy
        case geoObjectDescription = "description"
        case name
        case point = "Point"
    }
}

// MARK: - BoundedBy
struct BoundedBy: Codable {
    let envelope: Envelope

    enum CodingKeys: String, CodingKey {
        case envelope = "Envelope"
    }
}

// MARK: - Envelope
struct Envelope: Codable {
    let lowerCorner, upperCorner: String
}

// MARK: - GeoObjectMetaDataProperty
struct GeoObjectMetaDataProperty: Codable {
    let geocoderMetaData: GeocoderMetaData

    enum CodingKeys: String, CodingKey {
        case geocoderMetaData = "GeocoderMetaData"
    }
}

// MARK: - GeocoderMetaData
struct GeocoderMetaData: Codable {
    let text, kind, precision: String
    let address: Address
    let addressDetails: AddressDetails

    enum CodingKeys: String, CodingKey {
        case text, kind, precision
        case address = "Address"
        case addressDetails = "AddressDetails"
    }
}

// MARK: - Address
struct Address: Codable {
    let components: [Component]
    let formatted, countryCode: String

    enum CodingKeys: String, CodingKey {
        case components = "Components"
        case formatted
        case countryCode = "country_code"
    }
}

// MARK: - Component
struct Component: Codable {
    let kind, name: String
}

// MARK: - AddressDetails
struct AddressDetails: Codable {
    let country: Country

    enum CodingKeys: String, CodingKey {
        case country = "Country"
    }
}

// MARK: - Country
struct Country: Codable {
    let addressLine: String
    let administrativeArea: AdministrativeArea
    let countryName, countryNameCode: String

    enum CodingKeys: String, CodingKey {
        case addressLine = "AddressLine"
        case administrativeArea = "AdministrativeArea"
        case countryName = "CountryName"
        case countryNameCode = "CountryNameCode"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let administrativeAreaName: String

    enum CodingKeys: String, CodingKey {
        case administrativeAreaName = "AdministrativeAreaName"
    }
}

// MARK: - Point
struct Point: Codable {
    let pos: String
}

// MARK: - GeoObjectCollectionMetaDataProperty
struct GeoObjectCollectionMetaDataProperty: Codable {
    let geocoderResponseMetaData: GeocoderResponseMetaData

    enum CodingKeys: String, CodingKey {
        case geocoderResponseMetaData = "GeocoderResponseMetaData"
    }
}

// MARK: - GeocoderResponseMetaData
struct GeocoderResponseMetaData: Codable {
    let request: String
    let boundedBy: BoundedBy
    let found, results: String
}
