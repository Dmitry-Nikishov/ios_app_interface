//
//  YandexGeocoding.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 11.01.2022.
//
import Foundation
import Alamofire

class YandexGeocoding {
    private let api_key : String = "269b7eb2-a926-4635-b8b6-f6e9c2883002"
    private let geocoding_url : String = "https://geocode-maps.yandex.ru/1.x"
    
    static var shared: YandexGeocoding = {
        let instance = YandexGeocoding()
        return instance
    }()

    private init() {}

    func getGeoCode(geocode : String) -> GeoPosition? {
        let semaphore = DispatchSemaphore(value: 0)
        
        var apiResult : GeoPosition? = nil
        
        let params: [String : String] = ["format": "json", "apikey": api_key, "geocode" : "\(geocode)"]
        
        AF.request(geocoding_url, method: HTTPMethod.get, parameters: params).responseJSON(queue: DispatchQueue.global(qos: .utility) ) { [weak semaphore] response in
            switch response.result {
            case .success:
                if let result = try? JSONDecoder().decode(YandexGeocoderResponse.self, from: response.data!) {
                    if let geoObject = result.response.geoObjectCollection.featureMember.first?.geoObject {
                        apiResult = GeoPositionExtractor.extract(from: geoObject.point.pos)
                    }
                }
            case .failure:
                ()
            }
            
            semaphore?.signal()
        }
        
        semaphore.wait()
        return apiResult
    }
}

